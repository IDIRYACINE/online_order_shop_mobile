import 'dart:convert';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';

class ProductsMapper {
  late final IProductsDatabase _database;

  ProductsMapper(IProductsDatabase productsDatabase) {
    _database = productsDatabase;
  }

  Future<List<Product>> getProducts(
      {required String categoryId,
      required int startIndex,
      required int productsCount}) async {
    List<Product> products = [];

    ResultSet productsResultSet = await _database.loadProducts(
        category: categoryId, startIndex: startIndex, count: productsCount);

    for (int i = 0; i < productsResultSet.length; i++) {
      products.add(_mapResultSetToProduct(productsResultSet[i]));
    }
    return products;
  }

  Future<CategoryMap> getCategories() async {
    CategoryMap categories = [];
    Category tempCategory;
    ResultSet categoriesResultSet = await _database.loadCategories();
    for (int i = 0; i < categoriesResultSet.length; i++) {
      tempCategory = _mapResultSetToCategory(categoriesResultSet[i]);
      categories.add(tempCategory);
    }

    return categories;
  }

  Product _mapResultSetToProduct(QueryResult queryResult) {
    String rawSize = queryResult['Size'] as String;
    String rawPrice = queryResult['Price'] as String;

    List<String> sizes = List<String>.from(jsonDecode(rawSize));
    List<double> price = _rawStringToList(rawPrice);

    return Product(
        queryResult['Name'] as String,
        queryResult['Description'] as String,
        queryResult['ImageUrl'] as String,
        price,
        sizes,
        queryResult['Id'] as int);
  }

  List<double> _rawStringToList(String raw) {
    List<double> result = [];
    late double temp;

    for (var element in List<dynamic>.from(jsonDecode(raw))) {
      try {
        temp = double.parse(element);
        result.add(temp);
      } catch (error) {
        result.add(element.toDouble());
      }
    }
    return result;
  }

  Category _mapResultSetToCategory(QueryResult queryResult) {
    return Category(
        id: queryResult['Id'] as String,
        name: queryResult['Name'] as String,
        imageUrl: queryResult['ImageUrl'] as String,
        productsCount: queryResult['ProductsCount'] as int);
  }

  void removeProduct(Category category, Product product) {
    _database.deleteProduct(category, product);
  }

  void updateCategory(Category category) {
    _database.updateCategory(category);
  }

  void createCategory(Category category) {
    _database.createCategory(category);
  }

  void updateProduct(Category category, Product product) {
    _database.updateProduct(category, product);
  }

  void createProduct(Category category, Product product) {
    _database.createProduct(category, product);
  }

  void removeCategory(Category category) {
    _database.deleteCategory(category);
  }
}
