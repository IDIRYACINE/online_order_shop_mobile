// ignore_for_file: empty_catches

import 'dart:io';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/Exceptions/server_exceptions.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';
import 'package:sqflite/sqflite.dart';

class ProductsDatabase implements IProductsDatabase {
  static const String _productsDatabaseName = 'Products.db';
  static const String _categoriresTable = "Categories";
  late Database _productsDatabase;
  final IOnlineServerAcess _serverAccess;
  bool somethingChanged = false;

  ProductsDatabase(this._serverAccess);

  @override
  Future<void> connect() async {
    File databaseFile = await _getLocalDatabaseFile();

    if (!await databaseFile.exists()) {
      try {
        _serverAccess.downloadFile(
            fileUrl: _productsDatabaseName, out: databaseFile);
      } catch (e) {
        //throw RemoteDatabaseNotFound();
      }
    }

    try {
      await _connectToLocalDatabase(localDatabasePath: databaseFile.path);
    } catch (e) {
      throw LocalDatabaseNotFound();
    }

    try {
      int databaseVersion = await _serverAccess.fetchData(dataUrl: 'version');

      if (await _checkForNewVersion(databaseVersion)) {
        disconnect();
        await _serverAccess.downloadFile(
            fileUrl: _productsDatabaseName, out: databaseFile);
        await _connectToLocalDatabase(localDatabasePath: databaseFile.path);
        _productsDatabase.setVersion(databaseVersion);
      }
    } catch (e) {
      // dont care
    }
  }

  @override
  Future<void> disconnect() async {
    _productsDatabase.close();
  }

  @override
  Future<ResultSet> loadCategories() async {
    return await _productsDatabase.query('Categories',
        columns: ['Name', 'ImageUrl', 'ProductsCount', 'Id']);
  }

  @override
  Future<ResultSet> loadProducts(
      {required String category,
      required int startIndex,
      required int count}) async {
    return await _productsDatabase.query(category,
        columns: ['Id', 'Name', 'Description', 'Price', 'ImageUrl', 'Size'],
        limit: count,
        offset: startIndex);
  }

  Future<File> _getLocalDatabaseFile() async {
    String path = await getDatabasesPath();
    File databaseFile = File('$path/$_productsDatabaseName');
    return databaseFile;
  }

  Future<void> _connectToLocalDatabase(
      {required String localDatabasePath}) async {
    _productsDatabase = await openDatabase(localDatabasePath);
  }

  Future<bool> _checkForNewVersion(int fireBaseDatabaseVersion) async {
    int localDatabaseVersion = await _productsDatabase.getVersion();
    bool newUpdateAvaillable =
        (localDatabaseVersion != fireBaseDatabaseVersion);

    return newUpdateAvaillable;
  }

  @override
  Future<void> createCategory(Category category) async {
    Map<String, Object?> categoryValues = category.toMap();
    categoryValues['Id'] = category.getName();

    _productsDatabase.insert(_categoriresTable, categoryValues);

    String createCategoryTable =
        "CREATE TABLE IF NOT EXISTS ${category.getName()} ("
        "	Id Integer PRIMARY KEY AUTOINCREMENT,"
        "	Name text NOT NULL,"
        "	ImageUrl text NOT NULL,"
        "	Price text NOT NULL,"
        "	Size text NOT NULL,"
        "	Description text DEFAULT '' NOT NULL"
        ")";

    _productsDatabase.execute(createCategoryTable);
  }

  @override
  Future<void> createProduct(Category category, Product product) async {
    _productsDatabase.insert(category.getId(), product.toMap());
    updateCategoryProductCount(1, category.getId());
  }

  @override
  Future<void> deleteCategory(Category category) async {
    _productsDatabase.delete(_categoriresTable,
        where: "id=?", whereArgs: [category.getId()]);

    String dropCategoryTable = "DROP TABLE ${category.getId()}";
    _productsDatabase.execute(dropCategoryTable);
  }

  @override
  Future<void> deleteProduct(Category category, Product product) async {
    _productsDatabase.delete(category.getId(),
        where: "Name=?", whereArgs: [product.getName()]);
    updateCategoryProductCount(-1, category.getId());
  }

  @override
  Future<void> updateCategory(Category category) async {
    _productsDatabase.update(_categoriresTable, category.toMap());
  }

  @override
  Future<void> updateProduct(Category category, Product product) async {
    _productsDatabase.update(category.getId(), product.toMap(),
        where: "Id=?", whereArgs: [product.getId()]);
  }

  @override
  Future<bool> upgradeDatabaseVersion() async {
    if (somethingChanged) {
      int currentVersion = await _productsDatabase.getVersion();
      _productsDatabase.setVersion(currentVersion + 1);
      somethingChanged = false;
      return true;
    }
    return false;
  }

  void updateCategoryProductCount(int step, String categoryId) {
    String updateCategoryProductCount =
        "UPDATE $_categoriresTable SET ProductsCount = ProductsCount+$step WHERE Id = ?";

    _productsDatabase.execute(updateCategoryProductCount, [categoryId]);
  }

  @override
  void remebmerChange() {
    somethingChanged = true;
  }
}
