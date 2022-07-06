import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';

typedef ResultSet = List<QueryResult>;
typedef QueryResult = Map<String, Object?>;

abstract class IProductsDatabase {
  Future<void> connect();
  Future<void> disconnect();
  Future<ResultSet> loadProducts(
      {required String category, required int startIndex, required int count});
  Future<ResultSet> loadCategories();
  Future<void> deleteProduct(Category category, Product product);
  Future<void> deleteCategory(Category category);
  Future<void> createCategory(Category category);
  Future<void> createProduct(Category category, Product product);
  Future<void> updateProduct(Category category, Product product);
  Future<void> updateCategory(Category category);
  Future<bool> upgradeDatabaseVersion();
  void remebmerChange();
  Future<void> reset();
}
