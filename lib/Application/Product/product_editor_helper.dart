import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:online_order_shop_mobile/Application/Category/category_manager_helper.dart';
import 'package:online_order_shop_mobile/Application/Product/size_editor_helper.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart'
    as my_app;

import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';
import 'dart:developer' as dev;

class ProductEditorHelper {
  late Product _product;

  late my_app.Category _category;

  final IOnlineServerAcess _server;

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

  ProductEditorHelper(this._server, this._productsDatabase);

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
        if (_updatedImage) {
          String url = await _server.uploadFile(
              fileUrl: image.value, name: _tempProduct.getName());

          imageUrl = url;
        }

        _tempProduct.transfer(_product);

        _productsDatabase.updateProduct(_category, _product);

        _somethingChanged = false;
        _updatedImage = false;

        return;
      }

      String url = await _server.uploadFile(
          fileUrl: image.value, name: _tempProduct.getName());

      imageUrl = url;

      _categoryManagerHelper.addProduct(_tempProduct);

      _somethingChanged = false;
      _updatedImage = false;
    }
  }

  Future<void> browseImage() async {
    /* final ImagePicker _picker = ImagePicker();
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      if (_firstLoad.value == true) {
        _firstLoad.value = false;
      }

      image.value = imageFile.path;
      imageUrl = image.value;
    }*/
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      image.value = result.files.single.path!;
      dev.log(result.files.single.path!);
            

      imageUrl = image.value;
    } else {
      // User canceled the picker
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
}
