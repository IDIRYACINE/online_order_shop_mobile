import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_order_shop_mobile/Application/Product/size_editor_helper.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart'
    as my_app;

import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';

class ProductEditorHelper {
  late Product _product;

  late my_app.Category _category;

  final IOnlineServerAcess _server;

  final IProductsDatabase _productsDatabase;

  late Product _tempProduct;

  bool _somethingChanged = false;

  late bool _editMode;

  bool _updatedImage = false;

  late SizeEditorHelper _sizeEditorHelper;

  final ValueNotifier<String> image = ValueNotifier("");

  final ValueNotifier<bool> _firstLoad = ValueNotifier(true);

  ValueListenable<bool> get firstLoad => _firstLoad;

  bool get editMode => _editMode;

  Product get product => _tempProduct;

  get formCounter => null;

  String getSize(int index) => _tempProduct.getSize(index);

  String getPrice(int index) => _tempProduct.getPrice(index).toString();

  String get name => _product.getName();

  String get description => _product.getName();

  ValueListenable<int> get modelsCount => _sizeEditorHelper.getModelsCount();

  String get imageUrl => _product.getName();

  ProductEditorHelper(this._server, this._productsDatabase);

  void setProduct(my_app.Category category, Product product,
      [bool editMode = true]) {
    _product = product;

    _tempProduct = Product.from(product);

    _category = category;

    _editMode = editMode;

    _firstLoad.value = true;

    image.value = _tempProduct.getImageUrl();
  }

  set name(String name) {
    _tempProduct.setName(name);
    _somethingChanged = true;
  }

  set description(String description) {
    _tempProduct.setDescription(description);
    _somethingChanged = true;
  }

  set imageUrl(String imageUrl) {
    _tempProduct.setImageUrl(imageUrl);
    _updatedImage = true;
  }

  void setName(String value) {
    _tempProduct.setName(name);
    _somethingChanged = true;
  }

  void setDescription(String value) {
    _tempProduct.setDescription(description);
    _somethingChanged = true;
  }

  Future<void> applyChanges() async {
    if (_somethingChanged || _updatedImage) {
      String imageNameOnServer = "";

      _productsDatabase.remebmerChange();

      if (_editMode) {
        if (_updatedImage) {
          imageNameOnServer =
              _server.serverImageNameFormater(_product.getName());

          String url =
              ""; /*TODO : here await _server.uploadFile(
              fileUrl: image.value, name: imageNameOnServer);*/

          imageUrl = url;
        }
        _tempProduct.transfer(_product);

        _productsDatabase.updateProduct(_category, _product);

        return;
      }
      imageNameOnServer = _server.serverImageNameFormater(_product.getName());

      String url =
          "https://img-19.commentcamarche.net/cI8qqj-finfDcmx6jMK6Vr-krEw=/1500x/smart/b829396acc244fd484c5ddcdcb2b08f3/ccmcms-commentcamarche/20494859.jpg";

      imageUrl = url;

      _tempProduct.transfer(_product);

      _productsDatabase.createProduct(_category, _product);

      _somethingChanged = false;
      _updatedImage = false;
    }
  }

  Future<void> browseImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      if (_firstLoad.value == true) {
        _firstLoad.value = false;
      }

      image.value = imageFile.path;
      imageUrl = image.value;
    }
  }

  void applyModelsChanges() {
    _sizeEditorHelper.applyModelsChanges();
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
