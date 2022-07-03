// ignore_for_file: unused_field

typedef ProductMap = Map<String, List<Product>>;

class Product {
  String _name, _description, _imageUrl;
  final List<double> _prices;
  final List<String> _sizes;
  late final List<String> _descriptionImages;
  int? _id;

  Product(
      this._name, this._description, this._imageUrl, this._prices, this._sizes,
      [this._id]);

  String getDescription() {
    return _description;
  }

  String getImageUrl() {
    return _imageUrl;
  }

  String getName() {
    return _name;
  }

  double getPrice([int index = 0]) {
    return _prices[index];
  }

  String getSize(int index) {
    return _sizes[index];
  }

  int getPricesCount() {
    return _prices.length;
  }

  int getSizesCount() {
    return _sizes.length;
  }

  String getDescriptionImageUrl(int index) {
    return _imageUrl;
  }

  int getDescrpitionImagesCount() {
    return 1;
  }

  int? getId() {
    return _id;
  }

  Map<String, Object?> toMap() {
    return {
      "Name": _name,
      "Description": _description,
      "ImageUrl": _imageUrl,
      "Size": _sizes.toString(),
      "Price": _prices.toString(),
    };
  }

  List<double> getPriceList() {
    return _prices;
  }

  List<String> getSizeList() {
    return _sizes;
  }

  static Product from(Product source) {
    return Product(source.getName(), source.getDescription(),
        source.getImageUrl(), source.getPriceList(), source.getSizeList());
  }

  void transfer(Product target) {
    target.setSizeList(_sizes);
    target.setPriceList(_prices);
    target.setName(_name);
    target.setImageUrl(_imageUrl);
    target.setDescription(_description);
  }

  void setSizeList(List<String> sizeList) {
    _sizes.clear();
    _sizes.addAll(sizeList);
  }

  void setPriceList(List<double> priceList) {
    _prices.clear();
    _prices.addAll(priceList);
  }

  void setName(String name) {
    _name = name;
  }

  void setImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
  }

  void setDescription(String description) {
    _description = description;
  }
}
