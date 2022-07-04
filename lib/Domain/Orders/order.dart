import 'package:online_order_shop_mobile/Domain/Cart/cart_item.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'dart:developer' as dev;

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
  double? _totalPrice;

  Order(Map<String, dynamic> order) {
    dev.log(order.toString());
    _items = List.from(order["items"]);
    _orderId = order["id"];
    _orderStatus = "waiting"; //order["status"];
    _phoneNumber = order["phoneNumber"];
    _latitude = order["latitude"].toDouble();
    _longitude = order["longitude"].toDouble();
    _address = order["address"];
    _customerName = order["fullName"];
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
        price: productRaw["price"],
        quantity: productRaw["quantity"],
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
    if (_totalPrice != null) {
      return _totalPrice!;
    }
    _totalPrice = 0;
    int productsCount = _items.length;

    for (int i = 0; i < productsCount; i++) {
      _totalPrice =
          _totalPrice! + ((_items[i]["price"] * _items[i]["quantity"]));
    }

    return _totalPrice!;
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
