import 'package:online_order_shop_mobile/Application/DeliveryAddress/latlng.dart';
import 'package:online_order_shop_mobile/Domain/Cart/cart_item.dart';

abstract class IOrder {
  String getId();
  String getStatus();
  String getCustomerName();
  String getPhoneNumber();
  String getAddress();
  double getLatitude();
  double getLongitude();
  String getEmail();
  CartItem getItem(int index);
  int getItemsCount();
  double getTotalPrice();
  void setOrderStatus(String newStatus);
}
