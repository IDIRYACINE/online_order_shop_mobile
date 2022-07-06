import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart'
    as my_app;
import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/Product/product_widget.dart';

class CategoryManagerHelper {
  final ValueNotifier<int> productChangeCounter = ValueNotifier(0);

  final IProductsDatabase _productsDatabase;

  late my_app.Category _category;

  final CatalogueHelper _catalogueHelper;

  ValueListenable<int> get productCount => _category.getProductCountObserver();

  final List<Product> _deletedProducts = [];

  final List<Product> _createdProducts = [];

  CategoryManagerHelper(this._catalogueHelper, this._productsDatabase);

  void setCategory(my_app.Category category) {
    _category = category;
  }

  void removeProduct(Product product) {
    _category.removeProduct(product);
    _deletedProducts.add(product);
  }

  void addProduct(Product product) {
    _category.addProduct(product);
    _createdProducts.add(product);
  }

  final BoxConstraints _defaultProductWidgetConstraints =
      const BoxConstraints(minHeight: 100, maxHeight: 150);

  Widget productWidgetBuilder(BuildContext context, int productIndex,
      [BoxConstraints? productConstraints]) {
    return ConstrainedBox(
        constraints: productConstraints ?? _defaultProductWidgetConstraints,
        child: ProductWidget(
          _category,
          _category.getProduct(productIndex: productIndex),
          index: productIndex,
        ));
  }

  Future<void> applyChanges() async {
    bool somethingChanged =
        _deletedProducts.isNotEmpty || _createdProducts.isNotEmpty;

    if (somethingChanged) {
      _productsDatabase.remebmerChange();

      for (Product product in _deletedProducts) {
        _productsDatabase.deleteProduct(_category, product);
        _deletedProducts.clear();
      }

      for (Product product in _createdProducts) {
        _productsDatabase.createProduct(_category, product);

        _createdProducts.clear();
      }
    }

    _catalogueHelper.updateCategory(_category);
  }

  ValueListenable<int> get productsCount => _category.getProductCountObserver();
}
/*
  my_app.Category getCategory(int index) {
    return _catalogueHelper.getCategory(index);
  }

  ValueListenable<int> getCategoriesCount() {
    return _catalogueHelper.getCategoriesCountListenable();
  }

  void removeCategory(my_app.Category category) {
    _catalogueHelper.removeCategory(category);
  }*/


