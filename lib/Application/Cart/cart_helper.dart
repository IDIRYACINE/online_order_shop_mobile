import 'package:flutter/widgets.dart';
import 'package:online_order_shop_mobile/Domain/Cart/cart.dart';
import 'package:online_order_shop_mobile/Domain/Cart/cart_item.dart';

class CartHelper {
  late Cart _cart;
  final VoidCallback _notifyChange;

  CartHelper(this._notifyChange);

  void addCartItem(CartItem cartItem, BuildContext context) {
    _cart.addProduct(product: cartItem);
    _notifyChange();
  }

  void init() {
    int count = _cart.getProductsCount();
    // TODO : Query image from db
  }

  int getCartItemCount() {
    return _cart.getProductsCount();
  }

  CartItem getProduct(int productId) {
    return _cart.getProduct(productId: productId);
  }

  String getTotalPrice() {
    return _cart.getTotalPrice().toStringAsFixed(2);
  }

  String _getTimeStamp() {
    DateTime now = DateTime.now();
    return '${now.hour} : ${now.minute}';
  }

  void setCart(Cart cart) {
    _cart = cart;
  }
}
