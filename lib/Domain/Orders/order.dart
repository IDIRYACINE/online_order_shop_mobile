import 'package:online_order_shop_mobile/Domain/Cart/cart_item.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';

class Order implements IOrder {
  late List<Map<String, dynamic>> _items;
  late String _orderId;
  late String _orderStatus;
  late String _address;
  late String _phoneNumber;
  late double _latitude;
  late double _longitude;
  late String _customerName;
  late String _email;

  Order(Map<String, dynamic> order) {
    _items = order["items"];
    _orderId = order["id"];
    _orderStatus = order["status"];
    _phoneNumber = order["phone"];
    _latitude = order["latitude"];
    _longitude = order["longitude"];
    _address = order["address"];
    _customerName = order["customerName"];
    _email = order["email"];
  }

  @override
  String getStatus() {
    return _orderStatus;
  }

  @override
  String getId() {
    return _orderId;
  }

  @override
  String getAddress() {
    return _address;
  }

  @override
  String getCustomerName() {
    return _customerName;
  }

  @override
  CartItem getItem(int index) {
    Map<String, dynamic> productRaw = _items[index];

    return CartItem(
        name: productRaw["name"],
        price: productRaw["name"],
        quantity: productRaw["name"],
        size: productRaw["size"]);
  }

  @override
  int getItemsCount() {
    return _items.length;
  }

  @override
  String getPhoneNumber() {
    return _phoneNumber;
  }

  @override
  String getEmail() {
    return _email;
  }

  @override
  double getTotalPrice() {
    return 0;
  }

  @override
  void setOrderStatus(String newStatus) {
    _orderStatus = newStatus;
  }

  @override
  double getLatitude() {
    return _latitude;
  }

  @override
  double getLongitude() {
    return _longitude;
  }
}
