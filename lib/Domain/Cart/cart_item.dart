class CartItem {
  late String _name;
  late int _quantity;
  late num _price;
  late String _size;
  late String _imageUrl;

  CartItem({
    required String name,
    required int quantity,
    required String size,
    required num price,
    required String? imageUrl,
  }) {
    _name = name;
    _quantity = quantity;
    _price = price;
    _size = size;
    _imageUrl = imageUrl ?? "";
  }

  String getName() {
    return _name;
  }

  num getPrice() {
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

  void setImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
  }
}
