class CartItem {
  late String _name;
  late int _quantity;
  late double _price;
  late String _size;
  late String _imageUrl;

  CartItem(
      {required String name,
      required int quantity,
      required String size,
      required double price}) {
    _name = name;
    _quantity = quantity;
    _price = price;
    _size = size;
  }

  String getName() {
    return _name;
  }

  double getPrice() {
    return _price * _quantity;
  }

  int getQuantity() {
    return _quantity;
  }

  String getThumbnailUrl() {
    return _imageUrl;
  }

  String getSize() {
    return _size;
  }
}
