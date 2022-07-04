import 'package:flutter/widgets.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'package:online_order_shop_mobile/Domain/Orders/order_status.dart';
import 'package:online_order_shop_mobile/Infrastructure/Orders/iorder_subscriber.dart';

class OrdersProvider with ChangeNotifier implements IOrderSubscriber {
  final String _id = "OrderScreen";
  Map<String, IOrder> ordersLists = {};
  int _selectedTabIndex = 0;

  // 0 : waiting , 1 : confirmed , 2 : delivery
  final List<List<IOrder>> orders = [[], [], []];

  @override
  String getId() {
    return _id;
  }

  @override
  void notifyNewOrder(IOrder order) {
    String status = order.getStatus();
    ordersLists[order.getId()] = order;
    if (status == OrderStatus.waiting) {
      orders[0].add(order);
    } else if (status == OrderStatus.confirmed) {
      orders[1].add(order);
    } else {
      orders[2].add(order);
    }
    notifyListeners();
  }

  @override
  void notifyOrderStatusChange(String orderId, String status) {
    IOrder order = ordersLists[orderId]!;

    _removeOldOrder(order);

    order.setOrderStatus(status);

    notifyNewOrder(order);
  }

  int getOrdersCount(int index) {
    return orders[index].length;
  }

  IOrder getOrder(int tabIndex, int orderIndex) {
    return orders[tabIndex][orderIndex];
  }

  @override
  void notifyDeleteOrder(String orderId) {
    IOrder order = ordersLists[orderId]!;

    _removeOldOrder(order);

    notifyListeners();
  }

  void _removeOldOrder(IOrder order) {
    String oldStatus = order.getStatus();

    if (oldStatus == OrderStatus.waiting) {
      orders[0].remove(order);
    } else if (oldStatus == OrderStatus.confirmed) {
      orders[1].remove(order);
    } else {
      orders[2].remove(order);
    }
  }

  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
  }

  int get selectedTabIndex => _selectedTabIndex;
}
