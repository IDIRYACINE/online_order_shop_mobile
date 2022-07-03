import 'package:online_order_shop_mobile/Infrastructure/Orders/iorder_subscriber.dart';

abstract class IOrderService {
  void updateOrderStatus(String status, String orderId);
  void subscribeToOrdersStream(IOrderSubscriber subscriber);
  void unsubscribeFromOrdersStream(String subscriberId);
  void cancelAllSubscribtions();
  void listenToOrderStreamOnServer();
  void listenToOrderStatusStreamOnServer();
  void deleteOrder(String orderId);
  Future<void> onFirstConnect();
}
