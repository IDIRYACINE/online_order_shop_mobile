// ignore_for_file: unused_field, prefer_final_fields

import 'package:online_order_shop_mobile/Infrastructure/Database/products_mapper.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';

import 'product_model.dart';

typedef CategoryMap = List<Category>;

class Category {
  late String _id;
  late String _name;
  late String _imageUrl;
  late int _productCount;
  int _loadedProductsCount = 0;
  final List<Product> _products = [];

  Category(
      {required String id,
      required String name,
      required String imageUrl,
      required int productsCount}) {
    _id = id;
    _name = name;
    _imageUrl = imageUrl;
    _productCount = productsCount;
  }

  String getName() {
    return _name;
  }

  String getImageUrl() {
    return _imageUrl;
  }

  int getProductCount() {
    return _products.length;
  }

  Product getProduct({required int productIndex}) {
    return _products[productIndex];
  }

  Future<void> loadProducts({required int productsCount}) async {
    ProductsMapper mapper = ServicesProvider().productsMapper;

    List<Product> loadedProducts = await mapper.getProducts(
        categoryId: _id,
        startIndex: _loadedProductsCount,
        productsCount: productsCount);

    for (Product product in loadedProducts) {
      _products.add(product);
    }
  }

  String getId() {
    return _id;
  }

  Map<String, Object?> toMap() {
    return {
      "Name": _name,
      "ImageUrl": _imageUrl,
      "ProductsCount": _productCount
    };
  }

  void setImageUrl(String value) {
    _imageUrl = value;
  }

  static Category from(Category source) {
    return Category(
        id: source.getId(),
        name: source.getName(),
        imageUrl: source.getImageUrl(),
        productsCount: source.getProductCount());
  }

  void transfer(Category target) {
    target.setImageUrl(_imageUrl);
    target.setName(_name);
    target.setProductsCount(_productCount);
    target.setProducts(_products);
  }

  void setProductsCount(int productCount) {
    _productCount = productCount;
  }

  void setName(String name) {
    _name = name;
  }

  void setProducts(List<Product> products) {
    _products.clear();
    _products.addAll(products);
  }

  void removeProduct(Product product) {
    _products.remove(product);
  }

  void addProduct() {}

  void setId(String name) {
    _id = name;
  }
}
