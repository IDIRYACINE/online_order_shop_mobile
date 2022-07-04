import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';

abstract class IOrderSubscriber {
  void notifyNewOrder(IOrder order);
  void notifyOrderStatusChange(String orderId, String status);
  void notifyDeleteOrder(String orderId);
  String getId();
}
