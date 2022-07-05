import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/products_mapper.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';

class CatalogueModel {
  late ProductsMapper _productsManager;
  final int _categoryMaxProductDisplay = 5;
  late CategoryMap _categories;

  Future<void> initCategories() async {
    _productsManager = ServicesProvider().productsMapper;
    _categories = await _productsManager.getCategories();
    for (Category category in _categories) {
      await category.loadProducts(productsCount: _categoryMaxProductDisplay);
    }
  }

  Category getCategory({required int categoryIndex}) {
    return _categories[categoryIndex];
  }

  int getCategoriesCount() {
    return _categories.length;
  }

  void removeCategory(Category category) {
    _categories.remove(category);
    _productsManager.removeCategory(category);
  }

  void createProduct(Category category, Product product) {
    category.addProduct();
    _productsManager.createProduct(category, product);
  }

  void updateProduct(Category category, Product product) {
    _productsManager.updateProduct(category, product);
  }

  void createCategory(Category category) {
    _categories.add(category);
    _productsManager.createCategory(category);
  }

  void updateCategory(Category category) {
    _productsManager.updateCategory(category);
  }

  void removeProduct(Category category, Product product) {
    category.removeProduct(product);
    _productsManager.removeProduct(category, product);
  }
}
