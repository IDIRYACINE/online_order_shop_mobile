import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/Api/database_api.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/Exceptions/server_exceptions.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class RemoteDatabase implements IProductsDatabase {
  static const String _productsDatabaseName = 'Products.db';
  static const String _categoriresTable = "Categories";
  late Database _productsDatabase;
  final IOnlineServerAcess _serverAccess;
  final String _serverUrl;

  RemoteDatabase(this._serverAccess, this._serverUrl);

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
    _postRequest(createCategoryApi, {"category": json.encode(category)}, () {
      category['Id'] = category["Name"]!;

      _productsDatabase.insert(_categoriresTable, category);

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
    });
  }

  @override
  Future<void> createProduct(
      String categoryId, Map<String, String> product) async {
    _postRequest(
        createProductApi, {"product": product, "categoryId": categoryId}, () {
      _productsDatabase.insert(categoryId, product);
      updateCategoryProductCount(1, categoryId);
    });
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    _postRequest(deleteCategoryApi, {"categoryId": categoryId}, () {
      _productsDatabase
          .delete(_categoriresTable, where: "Id=?", whereArgs: [categoryId]);

      String dropCategoryTable = "DROP TABLE $categoryId";
      _productsDatabase.execute(dropCategoryTable);
    });
  }

  @override
  Future<void> deleteProduct(String categoryId, int productId) async {
    _postRequest(
        deleteProductApi, {"categoryId": categoryId, "productId": productId},
        () {
      _productsDatabase
          .delete(categoryId, where: "Id=?", whereArgs: [productId]);
      updateCategoryProductCount(-1, categoryId);
    });
  }

  @override
  Future<void> updateCategory(Map<String, String> category) async {
    _postRequest(updateCategoryApi, {"category": category}, () {
      _productsDatabase.update(_categoriresTable, category,
          where: "Id = ?", whereArgs: [category["Id"]]);
    });
  }

  @override
  Future<void> updateProduct(
      String categoryId, Map<String, String> product) async {
    _postRequest(
        updateProductApi, {"categoryId": categoryId, "product": product}, () {
      _productsDatabase.update(categoryId, product,
          where: "Id=?", whereArgs: [product["Id"]]);
    });
  }

  @override
  Future<bool> upgradeDatabaseVersion() async {
    _getRequest(synchroniseDatabaseApi, null, () {});
    return true;
  }

  void updateCategoryProductCount(int step, String categoryId) {
    String updateCategoryProductCount =
        "UPDATE $_categoriresTable SET ProductsCount = ProductsCount+$step WHERE Id = ?";

    _productsDatabase.execute(updateCategoryProductCount, [categoryId]);
  }

  @override
  void remebmerChange() {}

  @override
  Future<void> reset() async {
    _getRequest(resetDatabaseApi, null, () {});
  }

  Future<void> _postRequest(
      String api, Object? data, VoidCallback onSuccess) async {
    Uri uri = Uri(scheme: "http", host: _serverUrl, port: 3001, path: api);
    http.post(uri, body: data).then((response) {
      if (response.statusCode == 200) {
        onSuccess();
      } else {
        throw InternalServerError();
      }
    }).catchError((error) {
      throw InternalServerError();
    });
  }

  Future<void> _getRequest(
      String api, Object? data, VoidCallback onSuccess) async {
    Uri uri = Uri(scheme: "http", host: _serverUrl, path: api, port: 3001);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        onSuccess();
      } else {
        throw InternalServerError();
      }
    }).catchError((error) {
      throw InternalServerError();
    });
  }
}
