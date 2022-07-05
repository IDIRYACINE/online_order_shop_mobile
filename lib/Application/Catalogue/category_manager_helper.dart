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

  final ValueNotifier<String> imageUrl = ValueNotifier("");

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

    imageUrl.value = category.getImageUrl();

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
    String imageNameOnServer =
        _server.serverImageNameFormater(category.getId());

    if (_imageUpdated || _somethingChanged) {
      _productsDatabase.remebmerChange();

      _tempCategory.transfer(category);

      if (editMode) {
        if (_imageUpdated) {
          String url = await _server.uploadFile(
              fileUrl: imageUrl.value, name: imageNameOnServer);

          setImageUrl(url);
        }

        if (_deletedProducts.isNotEmpty) {
          for (Product product in _deletedProducts) {
            _catalogueHelper.removeProduct(category, product);
          }
        }

        _catalogueHelper.updateCategory(category);
        _somethingChanged = false;
        _imageUpdated = false;

        return;
      }

      String url = await _server.uploadFile(
          fileUrl: imageUrl.value, name: imageNameOnServer);

      setImageUrl(url);

      _catalogueHelper.createCategory(category);
    }
  }

  Future<void> browseImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // Maybe we should move the copy image from (cache) to internal storge , then upload
    if (image != null) {
      setImageUrl(image.path);
    }
  }

  void setImageUrl(String value) {
    _tempCategory.setImageUrl(value);
    imageUrl.value = value;
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
