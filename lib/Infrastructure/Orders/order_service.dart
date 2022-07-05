import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'package:online_order_shop_mobile/Domain/Orders/order.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';
import 'package:online_order_shop_mobile/Infrastructure/Orders/iorder_service.dart';
import 'package:online_order_shop_mobile/Infrastructure/Orders/iorder_subscriber.dart';

class OrderService implements IOrderService {
  StreamSubscription? _ordersStatusSubscription;

  StreamSubscription? _ordersSubscription;

  final Map<String, IOrderSubscriber> _ordersSubscribers = {};

  final IOnlineServerAcess _serverAcess;

  OrderService(this._serverAcess);

  @override
  void subscribeToOrdersStream(IOrderSubscriber subscriber) {
    String subscriberId = subscriber.getId();
    _ordersSubscribers[subscriberId] = subscriber;
  }

  @override
  void unsubscribeFromOrdersStream(String subscriberId) {
    _ordersSubscribers.remove(subscriberId);
  }

  @override
  void updateOrderStatus(String status, String orderId) {
    _serverAcess.postData(
        dataUrl: 'OrdersStatus/$orderId/status', data: status);
    _ordersSubscribers.forEach((key, subscriber) {
      subscriber.notifyOrderStatusChange(orderId, status);
    });
  }

  @override
  void listenToOrderStatusStreamOnServer() {
    // userId/status
    _ordersStatusSubscription ??=
        _serverAcess.getDataStream(dataUrl: "OrdersStatus").listen((event) {
      if (_ordersSubscribers.isEmpty) {
        return;
      }
      if ((event.type == DatabaseEventType.childChanged) ||
          (event.type == DatabaseEventType.value)) {
        Map<String, dynamic> orderStatus =
            Map.from(json.decode(json.encode(event.snapshot.value)));

        if (event.previousChildKey != null) {
          _ordersSubscribers.forEach((key, subscriber) {
            subscriber.notifyOrderStatusChange(
                event.snapshot.key!, orderStatus["status"]);
          });
        }
      }
    });
  }

  @override
  void listenToOrderStreamOnServer() {
    _ordersStatusSubscription ??=
        _serverAcess.getDataStream(dataUrl: "Orders").listen((event) {
      if (_ordersSubscribers.isEmpty) {
        return;
      }

      if ((event.type == DatabaseEventType.childAdded) ||
          (event.type == DatabaseEventType.value)) {
        Map<String, dynamic> orders =
            Map.from(json.decode(json.encode(event.snapshot.value)));

        _ordersSubscribers.forEach((key, subscriber) {
          orders.forEach((key, orderMap) {
            mapSnapshotToOrder(key, orderMap).then((order) {
              subscriber.notifyNewOrder(order);
            });
          });
        });
      }
    });
  }

  @override
  void deleteOrder(String orderId) {
    _serverAcess.removeData(dataUrl: "Orders/$orderId");
    _ordersSubscribers.forEach((key, subscriber) {
      subscriber.notifyDeleteOrder(orderId);
    });
  }

  @override
  void cancelAllSubscribtions() {
    if (_ordersStatusSubscription != null) {
      _ordersStatusSubscription!.cancel();
    }
    _ordersStatusSubscription = null;

    _ordersSubscribers.clear();
    if (_ordersSubscription != null) {
      _ordersSubscription!.cancel();
    }
    _ordersSubscription = null;
  }

  @override
  Future<void> onFirstConnect() async {
    listenToOrderStatusStreamOnServer();
    listenToOrderStreamOnServer();
  }

  Future<IOrder> mapSnapshotToOrder(
      String orderId, Map<String, dynamic> map) async {
    await _serverAcess
        .fetchData(dataUrl: "OrderStatus/$orderId")
        .then((status) {
      map["status"] = status;
      map["id"] = orderId;
    });

    return Order(map);
  }
}
