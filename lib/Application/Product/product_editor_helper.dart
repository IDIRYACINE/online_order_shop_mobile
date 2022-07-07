import 'package:flutter/foundation.dart';
import 'package:online_order_shop_mobile/Application/Category/category_manager_helper.dart';
import 'package:online_order_shop_mobile/Application/Product/size_editor_helper.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart'
    as my_app;

import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';

class ProductEditorHelper {
  late Product _product;

  late my_app.Category _category;

  final IProductsDatabase _productsDatabase;

  late Product _tempProduct;

  late CategoryManagerHelper _categoryManagerHelper;

  bool _somethingChanged = false;

  late bool _editMode;

  bool _updatedImage = false;

  final SizeEditorHelper _sizeEditorHelper = SizeEditorHelper();

  final ValueNotifier<String> image = ValueNotifier("");

  final ValueNotifier<bool> _firstLoad = ValueNotifier(true);

  ValueListenable<bool> get firstLoad => _firstLoad;

  bool get editMode => _editMode;

  Product get product => _tempProduct;

  ValueListenable<int> get formCounter => _sizeEditorHelper.modelsChangeCounter;

  String getSize(int index) => _sizeEditorHelper.getTempSize(index);

  String getPrice(int index) => _sizeEditorHelper.getTempPrice(index);

  String get name => _tempProduct.getName();

  String get description => _tempProduct.getDescription();

  ValueListenable<int> get modelsCount => _sizeEditorHelper.getModelsCount();

  String get imageUrl => _tempProduct.getImageUrl();

  ProductEditorHelper(this._productsDatabase);

  void setProduct(my_app.Category category, Product product,
      CategoryManagerHelper categoryManagerHelper,
      [bool editMode = true]) {
    _categoryManagerHelper = categoryManagerHelper;

    _product = product;

    _tempProduct = Product.from(product);

    _category = category;

    _editMode = editMode;

    _firstLoad.value = true;

    _sizeEditorHelper.setUp(_tempProduct);

    image.value = _tempProduct.getImageUrl();
  }

  set imageUrl(String imageUrl) {
    _tempProduct.setImageUrl(imageUrl);
    _updatedImage = true;
  }

  void setName(String value) {
    _tempProduct.setName(value);

    _somethingChanged = true;
  }

  void setDescription(String value) {
    _tempProduct.setDescription(value);
    _somethingChanged = true;
  }

  Future<void> applyChanges() async {
    if (_somethingChanged || _updatedImage) {
      _productsDatabase.remebmerChange();

      if (_editMode) {
        _tempProduct.transfer(_product);

        _productsDatabase.updateProduct(_category, _product);

        _somethingChanged = false;
        _updatedImage = false;

        return;
      }

      _categoryManagerHelper.addProduct(_tempProduct);

      _somethingChanged = false;
      _updatedImage = false;
    }
  }

  void applyModelsChanges() {
    _sizeEditorHelper.applyModelsChanges();
    _somethingChanged = true;
  }

  String getTempPrice(int index) {
    return _sizeEditorHelper.getTempPrice(index);
  }

  void removeModel(int index) {
    _sizeEditorHelper.removeModel(index);
  }

  SizeEditorHelper modelHelper() {
    return _sizeEditorHelper;
  }

  void setImage(String url) {
    image.value = url;
    imageUrl = url;
  }
}
