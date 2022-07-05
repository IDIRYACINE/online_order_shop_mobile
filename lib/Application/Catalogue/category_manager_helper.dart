import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart'
    as my_app;
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/Product/product_widget.dart';

class CategoryManagerHelper {
  final ValueNotifier<int> productCount = ValueNotifier(0);

  final ValueNotifier<int> productChangeCounter = ValueNotifier(0);

  final IProductsDatabase _productsDatabase;

  final IOnlineServerAcess _server;

  late my_app.Category _category;

  late my_app.Category _tempCategory;

  final CatalogueHelper _catalogueHelper;

  final ValueNotifier<String> image = ValueNotifier("");

  final List<Product> _deletedProducts = [];

  CategoryManagerHelper(
      this._catalogueHelper, this._productsDatabase, this._server);

  String get name => _category.getName();

  my_app.Category get category => _category;

  bool _editMode = false;

  bool _somethingChanged = false;

  bool _imageUpdated = false;

  bool get editMode => _editMode;

  void setCategory(my_app.Category category, [bool editMode = true]) {
    _category = category;

    _editMode = editMode;

    _tempCategory = my_app.Category.from(category);

    image.value = category.getImageUrl();

    productCount.value = category.getProductCount();
  }

  void removeProduct(Product product) {
    category.removeProduct(product);
    _deletedProducts.add(product);
    productCount.value--;
    _somethingChanged = true;
  }

  final BoxConstraints _defaultProductWidgetConstraints =
      const BoxConstraints(minHeight: 100, maxHeight: 150);

  Widget productWidgetBuilder(BuildContext context, int productIndex,
      [BoxConstraints? productConstraints]) {
    return ConstrainedBox(
        constraints: productConstraints ?? _defaultProductWidgetConstraints,
        child: ProductWidget(
          category,
          category.getProduct(productIndex: productIndex),
          index: productIndex,
        ));
  }

  Future<void> applyChanges() async {
    if (_somethingChanged || _imageUpdated) {
      String imageNameOnServer = "";

      _productsDatabase.remebmerChange();

      if (_editMode) {
        if (_imageUpdated) {
          imageNameOnServer =
              _server.serverImageNameFormater(_category.getId());

          String url = await _server.uploadFile(
              fileUrl: image.value, name: imageNameOnServer);

          imageUrl = url;
        }
        _tempCategory.transfer(_category);

        _catalogueHelper.updateCategory(_category);

        return;
      }
      imageNameOnServer =
          _server.serverImageNameFormater(_tempCategory.getId());

      String url = await _server.uploadFile(
          fileUrl: image.value, name: imageNameOnServer);

      imageUrl = url;

      _tempCategory.transfer(_category);

      _catalogueHelper.createCategory(_category);

      _somethingChanged = false;
      _imageUpdated = false;
    }
  }

  Future<void> browseImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      image.value = imageFile.path;
      imageUrl = image.value;
    }
  }

  set imageUrl(String imageUrl) {
    _tempCategory.setImageUrl(imageUrl);
    _imageUpdated = true;
  }

  void setName(String value) {
    if (!editMode) {
      _tempCategory.setId(value);
    }
    _tempCategory.setName(value);
    _somethingChanged = true;
  }

  void abortChanges() {
    _deletedProducts.clear();
  }

  my_app.Category getCategory(int index) {
    return _catalogueHelper.getCategory(index);
  }

  int getCategoriesCount() {
    return _catalogueHelper.getCategoriesCount();
  }

  void removeCategory(my_app.Category category) {
    _catalogueHelper.removeCategory(category);
  }
}
