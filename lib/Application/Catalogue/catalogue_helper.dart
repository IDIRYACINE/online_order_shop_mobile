import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/catalogue_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/product_widget.dart';

class CatalogueHelper {
  final CatalogueModel _catalogueModel;
  final int _maxProductsPreview = 5;
  late Category _selectedCategory;
  CatalogueHelper(this._catalogueModel);

  Category getCategory([int? categoryIndex]) {
    if (categoryIndex != null) {
      return _catalogueModel.getCategory(categoryIndex: categoryIndex);
    }
    return _selectedCategory;
  }

  int getCategoriesCount() {
    return _catalogueModel.getCategoriesCount();
  }

  int previewProductCount(int categoryIndex) {
    int productCount = getCategory(categoryIndex).getProductCount();
    productCount =
        productCount > _maxProductsPreview ? _maxProductsPreview : productCount;
    return productCount;
  }

  Future<void> initCategories() async {
    await _catalogueModel.initCategories();
    _selectedCategory = _catalogueModel.getCategory(categoryIndex: 0);
  }

  void setSelectedCategory(int categoryIndex) {
    _selectedCategory =
        _catalogueModel.getCategory(categoryIndex: categoryIndex);
  }

  final BoxConstraints _defaultProductWidgetConstraints =
      const BoxConstraints(minHeight: 200, maxHeight: 400);

  Widget productWidgetBuilder(BuildContext context, int productIndex,
      [BoxConstraints? productConstraints]) {
    return ConstrainedBox(
        constraints: productConstraints ?? _defaultProductWidgetConstraints,
        child: ProductWidget(getCategory(),
            _selectedCategory.getProduct(productIndex: productIndex)));
  }

  void removeCategory(int index) {
    _catalogueModel.removeCategory(index);
  }

  void removeProduct(Category category, int productIndex) {
    _catalogueModel.removeProduct(category, productIndex);
  }

  void updateCategory(Category category) {
    _catalogueModel.updateCategory(category);
  }

  void createCategory(Category category) {
    _catalogueModel.createCategory(category);
  }

  void updateProduct(Category category, Product product) {
    _catalogueModel.updateProduct(category, product);
  }

  void createProduct(Category category, Product product) {
    _catalogueModel.createProduct(category, product);
  }
}