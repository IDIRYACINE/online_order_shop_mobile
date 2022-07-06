import 'package:flutter/foundation.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/catalogue_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart'
    as my_app;
import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';

class CatalogueHelper with ChangeNotifier {
  final CatalogueModel _catalogueModel;

  CatalogueHelper(this._catalogueModel);

  my_app.Category getCategory(int categoryIndex) {
    return _catalogueModel.getCategory(categoryIndex: categoryIndex);
  }

  int getCategoriesCount() {
    return _catalogueModel.getCategoriesCount();
  }

  ValueListenable<int> getCategoriesCountListenable() {
    return _catalogueModel.getCategoriesCountListenable();
  }

  Future<void> initCategories() async {
    await _catalogueModel.initCategories();
  }

  void removeCategory(my_app.Category category) {
    _catalogueModel.removeCategory(category);
  }

  void removeProduct(my_app.Category category, Product product) {
    _catalogueModel.removeProduct(category, product);
  }

  void updateCategory(my_app.Category category) {
    _catalogueModel.updateCategory(category);
  }

  void createCategory(my_app.Category category) {
    _catalogueModel.createCategory(category);

    notifyListeners();
  }

  void updateProduct(my_app.Category category, Product product) {
    _catalogueModel.updateProduct(category, product);
  }

  void createProduct(my_app.Category category, Product product) {
    _catalogueModel.createProduct(category, product);
  }

  Future<void> reloadCategories() async {
    _catalogueModel.clearCategories();
    await initCategories();
  }
}
