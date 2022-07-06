import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart'
    as my_app;
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';

class CategoryEditorHelper {
  late bool _editMode;

  bool _somethingChanged = false;

  bool _imageUpdated = false;

  late ValueNotifier<String> _image;
  late ValueNotifier<bool> _firstLoad;

  late my_app.Category _category;
  late my_app.Category _tempCategory;

  CategoryEditorHelper(my_app.Category category, [bool editMode = true]) {
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

      final IOnlineServerAcess _server = ServicesProvider().serverAcessService;

      String imageNameOnServer =
          _server.serverImageNameFormater(_category.getId());

      _productsDatabase.remebmerChange();

      if (_editMode) {
        if (_imageUpdated) {
          /*String url = await _server.uploadFile(
              fileUrl: image.value, name: imageNameOnServer);*/

          imageUrl = _image.value; //TODO : uirl
        }
        _tempCategory.transfer(_category);

        _productsDatabase.updateCategory(_category);

        return;
      }

      /*String url = await _server.uploadFile(
          fileUrl: image.value, name: imageNameOnServer);*/

      imageUrl = _image.value;

      _tempCategory.transfer(_category);

      _productsDatabase.createCategory(_category);

      _somethingChanged = false;
      _imageUpdated = false;
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

      _image.value = imageFile.path;
      imageUrl = _image.value;
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
}
