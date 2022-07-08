abstract class IDatabaseApi {
  Future<Map<String, String>> loadProducts(
      {required String category, required int startIndex, required int count});
  Future<Map<String, String>> loadCategories();
  Future<void> deleteProduct(String categoryId, String productId);
  Future<void> deleteCategory(String categoryId);
  Future<void> createCategory(Map<String, String> category);
  Future<void> createProduct(String categoryId, Map<String, String> product);
  Future<void> updateProduct(String categoryId, Map<String, String> product);
  Future<void> updateCategory(Map<String, String> category);
  Future<bool> upgradeDatabaseVersion();
  void remebmerChange();
  Future<void> reset();
}
