import 'package:online_order_shop_mobile/Domain/Cart/cart_item.dart';

class Cart {
  static final Cart _cartModel = Cart._();
  final List<CartItem> _products = [];

  factory Cart() {
    return _cartModel;
  }

  Cart._();

  void addProduct({required CartItem product}) {
    _products.add(product);
  }

  void clearCart() {
    _products.clear();
  }

  double getTotalPrice() {
    double totalPrice = 0;
    int productsCount = getProductsCount();
    for (int i = 0; i < productsCount; i++) {
      totalPrice += _products[i].getPrice();
    }
    return totalPrice;
  }

  int getProductsCount() {
    return _products.length;
  }

  CartItem getProduct({required int productId}) {
    return _products[productId];
  }
}
