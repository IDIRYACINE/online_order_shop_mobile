import 'package:flutter/foundation.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart'
    as my_app;
import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/products_mapper.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';

class CatalogueModel {
  late ProductsMapper _productsManager;
  final int _categoryMaxProductDisplay = 100;
  late my_app.CategoryMap _categories;
  late ValueNotifier<int> _categoriesCount;

  Future<void> initCategories() async {
    _productsManager = ServicesProvider().productsMapper;
    _categories = await _productsManager.getCategories();
    _categoriesCount = ValueNotifier(_categories.length);
    for (my_app.Category category in _categories) {
      await category.loadProducts(productsCount: _categoryMaxProductDisplay);
    }
  }

  my_app.Category getCategory({required int categoryIndex}) {
    return _categories[categoryIndex];
  }

  int getCategoriesCount() {
    return _categoriesCount.value;
  }

  //TODO : productDatabase remeberChange

  void removeCategory(my_app.Category category) {
    _categories.remove(category);
    _categoriesCount.value--;
    _productsManager.removeCategory(category);
  }

  void createProduct(my_app.Category category, Product product) {
    category.addProduct(product);
    _productsManager.createProduct(category, product);
  }

  void updateProduct(my_app.Category category, Product product) {
    _productsManager.updateProduct(category, product);
  }

  void createCategory(my_app.Category category) {
    _categories.add(category);
    _categoriesCount.value++;

    _productsManager.createCategory(category);
  }

  void updateCategory(my_app.Category category) {
    _productsManager.updateCategory(category);
  }

  void removeProduct(my_app.Category category, Product product) {
    category.removeProduct(product);
    _productsManager.removeProduct(category, product);
  }

  void clearCategories() {
    _categories.clear();
  }

  ValueListenable<int> getCategoriesCountListenable() {
    return _categoriesCount;
  }
}
