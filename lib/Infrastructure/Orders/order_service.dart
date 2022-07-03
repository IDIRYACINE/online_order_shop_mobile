import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'package:online_order_shop_mobile/Domain/Orders/order.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';
import 'package:online_order_shop_mobile/Infrastructure/Orders/iorder_service.dart';
import 'package:online_order_shop_mobile/Infrastructure/Orders/iorder_subscriber.dart';
import 'dart:developer' as dev;

class OrderService implements IOrderService {
  static const _orderStatusChannelName = "online_order_client/order_status";

  StreamSubscription? _ordersStatusSubscription;

  StreamSubscription? _ordersSubscription;

  final Map<String, IOrderSubscriber> _ordersSubscribers = {};

  final IOnlineServerAcess _serverAcess;

  final EventChannel _orderStatusChannel =
      const EventChannel(_orderStatusChannelName);

  /// Defining Method Channel and it's functions
  static const _controlsChannelName = "online_order_client/controls";

  static const _listenToOrderStatusMethod = "listenToOrderStatus";

  final MethodChannel _controlsChannel =
      const MethodChannel(_controlsChannelName);

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
    _serverAcess.postData(dataUrl: 'OrdersStatus/$orderId', data: status);
  }

  @override
  void listenToOrderStatusStreamOnServer() {
    // userId/status
    _ordersStatusSubscription ??=
        _serverAcess.getDataStream(dataUrl: "OrdersStatus").listen((event) {
      Map<String, dynamic> orderStatus =
          Map<String, dynamic>.from(json.decode(event.snapshot.value));

      if (event.previousSiblingKey != null) {
        _ordersSubscribers.forEach((key, subscriber) {
          subscriber.notifyOrderStatusChange(
              event.snapshot.key!, orderStatus["status"]);
        });
      }
    });
  }

  @override
  void listenToOrderStreamOnServer() {
    _ordersStatusSubscription ??=
        _serverAcess.getDataStream(dataUrl: "Orders").listen((event) {
      Map<String, dynamic> orders =
          Map<String, dynamic>.from(json.decode(event.snapshot.value));
      dev.log(orders.toString());

      _ordersSubscribers.forEach((key, subscriber) {
        orders.forEach((key, orderMap) {
          mapSnapshotToOrder(orderMap).then((order) {
            dev.log(order.toString());

            subscriber.notifyNewOrder(order);
          });
        });
      });
    });
  }

  @override
  void deleteOrder(String orderId) {
    _serverAcess.removeData(dataUrl: "Orders/$orderId");
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
    _serverAcess.fetchData(dataUrl: "Orders").then((orderMap) {
      _ordersSubscribers.forEach((key, subscriber) {
        mapSnapshotToOrder(orderMap)
            .then((order) => subscriber.notifyNewOrder(order));
      });
    });
  }

  Future<IOrder> mapSnapshotToOrder(Object value) async {
    DataSnapshot snapshot = value as DataSnapshot;

    Map<String, dynamic> jsonMap =
        Map<String, dynamic>.from(json.decode(snapshot.value));
    String orderId = snapshot.key!;

    _serverAcess.fetchData(dataUrl: "OrderStatus/$orderId").then((status) {
      jsonMap["status"] = status;
    });

    return Order(jsonMap);
  }
}
