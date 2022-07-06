import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart'
    as my_app;

import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';

class ProductManagerHelper {
  late Product _product;

  late my_app.Category _category;

  final IOnlineServerAcess _server;

  final IProductsDatabase _productsDatabase;

  List<String> _tempSizes = [];

  List<double> _tempPrices = [];

  late Product _tempProduct;

  bool _somethingChanged = false;

  late bool _editMode;

  bool _updatedImage = false;

  final ValueNotifier<int> modelsChangeCounter = ValueNotifier(0);

  final ValueNotifier<String> image = ValueNotifier("");

  final ValueNotifier<int> formCounter = ValueNotifier(0);

  final ValueNotifier<int> tempModelsCount = ValueNotifier(0);

  final CatalogueHelper _catalogueHelper;

  final ValueNotifier<bool> _firstLoad = ValueNotifier(true);

  ValueListenable<bool> get firstLoad => _firstLoad;

  ProductManagerHelper(
      this._server, this._productsDatabase, this._catalogueHelper);

  void setProduct(my_app.Category category, Product product,
      [bool editMode = true]) {
    _product = product;

    _tempProduct = Product.from(product);

    _category = category;

    _editMode = editMode;

    tempModelsCount.value = _tempProduct.getSizesCount();

    _firstLoad.value = true;

    image.value = _tempProduct.getImageUrl();

    _tempSizes = List.from(_tempProduct.getSizeList());

    _tempPrices = List.from(_tempProduct.getPriceList());
  }

  String get name => _product.getName();

  set name(String name) {
    _tempProduct.setName(name);
    _somethingChanged = true;
  }

  String get description => _product.getName();

  set description(String description) {
    _tempProduct.setDescription(description);
    _somethingChanged = true;
  }

  get modelsCount => _tempProduct.getSizesCount();

  String get imageUrl => _product.getName();

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

  bool get editMode => _editMode;

  Product get product => _tempProduct;

  String getSize(int index) => _tempProduct.getSize(index);

  String getPrice(int index) => _tempProduct.getPrice(index).toString();

  String getTempSize(int index) => _tempProduct.getSize(index);

  String getTempPrice(int index) => _tempProduct.getPrice(index).toString();

  void addModel(String size, String price) {
    _tempSizes.add(size);
    _tempPrices.add(double.parse(price));

    tempModelsCount.value++;
  }

  void removeModel(int index) {
    _tempSizes.removeAt(index);
    _tempPrices.removeAt(index);

    tempModelsCount.value--;
  }

  Future<void> applyChanges() async {
    if (_somethingChanged || _updatedImage) {
      String imageNameOnServer = "";

      _productsDatabase.remebmerChange();

      if (_editMode) {
        if (_updatedImage) {
          imageNameOnServer =
              _server.serverImageNameFormater(_product.getName());

          String url = await _server.uploadFile(
              fileUrl: image.value, name: imageNameOnServer);

          imageUrl = url;
        }
        _tempProduct.transfer(_product);

        _catalogueHelper.updateProduct(_category, _product);

        return;
      }
      imageNameOnServer = _server.serverImageNameFormater(_product.getName());

      String url = await _server.uploadFile(
          fileUrl: image.value, name: imageNameOnServer);

      imageUrl = url;

      _tempProduct.transfer(_product);
      _catalogueHelper.createProduct(_category, _product);

      _somethingChanged = false;
      _updatedImage = false;
    }
  }

  void updateModel(int index, String size, String price) {
    formCounter.value++;
    _tempProduct.updateModel(index, size, double.parse(price));
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
    _tempProduct.updateModels(_tempSizes, _tempPrices);
    modelsChangeCounter.value++;
    _somethingChanged = true;
  }
}
