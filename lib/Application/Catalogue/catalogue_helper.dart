import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/catalogue_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';

class CatalogueHelper with ChangeNotifier {
  final CatalogueModel _catalogueModel;

  CatalogueHelper(this._catalogueModel);

  Category getCategory(int categoryIndex) {
    return _catalogueModel.getCategory(categoryIndex: categoryIndex);
  }

  int getCategoriesCount() {
    return _catalogueModel.getCategoriesCount();
  }

  Future<void> initCategories() async {
    await _catalogueModel.initCategories();
  }

  void removeCategory(Category category) {
    _catalogueModel.removeCategory(category);
  }

  void removeProduct(Category category, Product product) {
    _catalogueModel.removeProduct(category, product);
  }

  void updateCategory(Category category) {
    _catalogueModel.updateCategory(category);
  }

  void createCategory(Category category) {
    _catalogueModel.createCategory(category);
    notifyListeners();
  }

  void updateProduct(Category category, Product product) {
    _catalogueModel.updateProduct(category, product);
  }

  void createProduct(Category category, Product product) {
    _catalogueModel.createProduct(category, product);
  }
}
