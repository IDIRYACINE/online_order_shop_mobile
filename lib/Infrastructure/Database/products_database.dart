// ignore_for_file: empty_catches

import 'dart:io';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';
import 'package:sqflite/sqflite.dart';

class ProductsDatabase implements IProductsDatabase {
  static const String _productsDatabaseName = 'Products.db';
  static const String _categoriresTable = "Categories";
  late Database _productsDatabase;
  final IOnlineServerAcess _serverAccess;
  bool _somethingChanged = false;

  ProductsDatabase(this._serverAccess);

  @override
  Future<void> connect() async {
    File databaseFile = await _getLocalDatabaseFile();

    if (!await databaseFile.exists()) {
      try {
        _serverAccess.downloadFile(
            fileUrl: _productsDatabaseName, out: databaseFile);
      } catch (e) {
        reset();
      }
    }

    try {
      await _connectToLocalDatabase(localDatabasePath: databaseFile.path);
    } catch (e) {
      reset();
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
      reset();
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
  Future<void> createCategory(Map<String, String> category) async {
    Map<String, Object?> categoryValues = category;
    categoryValues['Id'] = category["Name"];

    _productsDatabase.insert(_categoriresTable, categoryValues);

    String createCategoryTable =
        "CREATE TABLE IF NOT EXISTS ${category["Name"]} ("
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
  Future<void> createProduct(
      String categoryId, Map<String, String> product) async {
    _productsDatabase.insert(categoryId, product);
    updateCategoryProductCount(1, categoryId);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    _productsDatabase
        .delete(_categoriresTable, where: "Id=?", whereArgs: [categoryId]);

    String dropCategoryTable = "DROP TABLE $categoryId";
    _productsDatabase.execute(dropCategoryTable);
  }

  @override
  Future<void> deleteProduct(String categoryId, int productId) async {
    _productsDatabase.delete(categoryId, where: "Id=?", whereArgs: [productId]);
    updateCategoryProductCount(-1, categoryId);
  }

  @override
  Future<void> updateCategory(Map<String, String> category) async {
    _productsDatabase.update(_categoriresTable, category,
        where: "Id = ?", whereArgs: [category["Id"]]);
  }

  @override
  Future<void> updateProduct(
      String categoryId, Map<String, String> product) async {
    _productsDatabase
        .update(categoryId, product, where: "Id=?", whereArgs: [product["Id"]]);
  }

  @override
  Future<bool> upgradeDatabaseVersion() async {
    if (_somethingChanged) {
      int currentVersion = await _productsDatabase.getVersion();
      _productsDatabase.setVersion(currentVersion + 1);

      File databaseFile = await _getLocalDatabaseFile();

      _serverAccess.uploadFile(
          fileUrl: databaseFile.path, name: _productsDatabaseName);

      _serverAccess.postData(dataUrl: "version", data: currentVersion + 1);
      _somethingChanged = false;
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
    _somethingChanged = true;
  }

  @override
  Future<void> reset() async {
    File databaseFile = await _getLocalDatabaseFile();
    disconnect();

    String createCategoriesTable =
        "CREATE TABLE IF NOT EXISTS $_categoriresTable "
        " ("
        "	Id String PRIMARY KEY,"
        "	Name text NOT NULL,"
        "	ImageUrl text NOT NULL,"
        " ProductsCount Integer "
        ")";

    try {
      await _serverAccess.postData(dataUrl: 'version', data: 0);

      await _connectToLocalDatabase(localDatabasePath: databaseFile.path);
      _productsDatabase.execute(createCategoriesTable);

      _productsDatabase.setVersion(0);

      await _serverAccess.uploadFile(
          fileUrl: databaseFile.path, name: _productsDatabaseName);
    } catch (e) {
      // dont care
    }
  }
}
