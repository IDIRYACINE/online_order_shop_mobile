typedef ResultSet = List<QueryResult>;
typedef QueryResult = Map<String, Object?>;

abstract class IProductsDatabase {
  Future<void> connect();
  Future<void> disconnect();
  Future<ResultSet> loadProducts(
      {required String category, required int startIndex, required int count});
  Future<ResultSet> loadCategories();
  Future<void> deleteProduct(String categoryId, int productId);
  Future<void> deleteCategory(String categoryId);
  Future<void> createCategory(Map<String, String> category);
  Future<void> createProduct(String categoryId, Map<String, String> product);
  Future<void> updateProduct(String categoryId, Map<String, String> product);
  Future<void> updateCategory(Map<String, String> category);
  Future<bool> upgradeDatabaseVersion();
  void remebmerChange();
  Future<void> reset();
}
