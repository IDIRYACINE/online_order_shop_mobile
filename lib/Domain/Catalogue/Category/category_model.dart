// ignore_for_file: unused_field, prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/products_mapper.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';

import '../Product/product_model.dart';

typedef CategoryMap = List<Category>;

class Category {
  late String _id;
  late ValueNotifier<String> _name;
  late ValueNotifier<String> _imageUrl;
  late ValueNotifier<int> _productCount;
  int _loadedProductsCount = 0;
  final List<Product> _products = [];

  Category(
      {required String id,
      required String name,
      required String imageUrl,
      required int productsCount}) {
    _id = id;
    _name = ValueNotifier(name);
    _imageUrl = ValueNotifier(imageUrl);
    _productCount = ValueNotifier(productsCount);
  }

  String getName() {
    return _name.value;
  }

  String getImageUrl() {
    return _imageUrl.value;
  }

  ValueListenable<String> getImagePreviewListenable() {
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

  Map<String, String> toMap() {
    return {
      "Name": _name.value,
      "ImageUrl": _imageUrl.value,
      "ProductsCount": _productCount.value.toString()
    };
  }

  void setImageUrl(String value) {
    _imageUrl.value = value;
  }

  static Category from(Category source) {
    return Category(
        id: source.getId(),
        name: source.getName(),
        imageUrl: source.getImageUrl(),
        productsCount: source.getProductCount());
  }

  void transfer(Category target) {
    target.setId(_id);
    target.setImageUrl(_imageUrl.value);
    target.setName(_name.value);
    target.setProductsCount(_productCount.value);
    target.setProducts(_products);
  }

  void setProductsCount(int productCount) {
    _productCount.value = productCount;
  }

  void setName(String name) {
    _name.value = name;
  }

  ValueListenable<String> getNameObserver() {
    return _name;
  }

  ValueListenable<int> getProductCountObserver() {
    return _productCount;
  }

  void setProducts(List<Product> products) {
    _products.clear();
    _products.addAll(products);
  }

  void removeProduct(Product product) {
    _products.remove(product);
    _productCount.value--;
  }

  void addProduct(Product product) {
    _products.add(product);
    _productCount.value++;
  }

  void setId(String name) {
    _id = name;
  }
}
