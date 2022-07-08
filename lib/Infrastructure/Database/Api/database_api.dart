import 'package:online_order_shop_mobile/Infrastructure/Database/Api/idatabase_api.dart';

class DatabaseApi implements IDatabaseApi {
  @override
  Future<void> createCategory(Map<String, String> category) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<void> createProduct(String categoryId, Map<String, String> product) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCategory(String categoryId) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(String categoryId, String productId) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> loadCategories() {
    // TODO: implement loadCategories
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> loadProducts(
      {required String category, required int startIndex, required int count}) {
    // TODO: implement loadProducts
    throw UnimplementedError();
  }

  @override
  void remebmerChange() {
    // TODO: implement remebmerChange
  }

  @override
  Future<void> reset() {
    // TODO: implement reset
    throw UnimplementedError();
  }

  @override
  Future<void> updateCategory(Map<String, String> category) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(String category, Map<String, String> product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<bool> upgradeDatabaseVersion() {
    // TODO: implement upgradeDatabaseVersion
    throw UnimplementedError();
  }
}
