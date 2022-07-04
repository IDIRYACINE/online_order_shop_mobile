import 'package:online_order_shop_mobile/Domain/Cart/cart_item.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';

class Cart {
  final List<CartItem> _products = [];
  final IOrder _order;

  Cart(this._order);

  void addProduct({required CartItem product}) {
    _products.add(product);
  }

  double getTotalPrice() {
    return _order.getTotalPrice();
  }

  int getProductsCount() {
    return _order.getItemsCount();
  }

  CartItem getProduct({required int productId}) {
    return _order.getItem(productId);
  }
}
