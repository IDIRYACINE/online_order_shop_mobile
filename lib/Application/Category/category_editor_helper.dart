import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/ImagePicker/image_picker_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart'
    as my_app;
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';

class CategoryEditorHelper {
  late bool _editMode;

  bool _somethingChanged = false;

  bool _imageUpdated = false;

  late ValueNotifier<String> _image;
  late ValueNotifier<bool> _firstLoad;

  late my_app.Category _category;
  late my_app.Category _tempCategory;

  final CatalogueHelper _catalogueHelper;

  CategoryEditorHelper(this._catalogueHelper);

  void setCategory(my_app.Category category, [bool editMode = true]) {
    _category = category;
    _image = ValueNotifier(category.getImageUrl());
    _firstLoad = ValueNotifier(true);
    _editMode = editMode;
    _tempCategory = my_app.Category.from(_category);
  }

  bool get editMode => _editMode;

  ValueListenable<String> get image => _image;

  ValueListenable<bool> get firstLoad => _firstLoad;

  String get name => _tempCategory.getName();

  Future<void> applyChanges() async {
    if (_somethingChanged || _imageUpdated) {
      final IProductsDatabase _productsDatabase =
          ServicesProvider().productDatabase;

      _productsDatabase.remebmerChange();

      if (_editMode) {
        _tempCategory.transfer(_category);

        _productsDatabase.updateCategory(_category);

        return;
      }

      _tempCategory.transfer(_category);

      _catalogueHelper.createCategory(_category);

      _somethingChanged = false;
      _imageUpdated = false;
    }
  }

  void setImage(String url) {
    _image.value = url;
    imageUrl = url;
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
}
