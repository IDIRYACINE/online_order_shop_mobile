import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/local_image.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_image.dart';
import 'package:online_order_shop_mobile/Ui/Components/cards.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as dev;

class CategoryManagerScreen extends StatefulWidget {
  final bool editMode;
  final Category? category;
  const CategoryManagerScreen({Key? key, required this.editMode, this.category})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends State<CategoryManagerScreen> {
  late Category category;
  late CatalogueHelper catalogueHelper;
  late ValueNotifier<String> imageUrl;
  bool imageChanged = false;

  Future<void> saveChanges() async {
    IOnlineServerAcess server = ServicesProvider().serverAcessService;
    category.transfer(widget.category!);

    if (widget.editMode) {
      if (imageChanged) {
        String url = await server.uploadFile(
            fileUrl: imageUrl.value, name: category.getId());
        category.setImageUrl(url);
      }
      catalogueHelper.updateCategory(category);
      return;
    }

    String url = await server.uploadFile(
        fileUrl: imageUrl.value, name: category.getId());
    category.setImageUrl(url);
    catalogueHelper.createCategory(category);
  }

  void setup() {
    category = Category.from(widget.category!);
    imageUrl = ValueNotifier(category.getImageUrl());
  }

  Future<void> browseImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // Maybe we should move the copy image from (cache) to internal storge , then upload
    if (image != null) {
      imageUrl.value = image.path;
      imageChanged = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    catalogueHelper =
        Provider.of<HelpersProvider>(context, listen: false).catalogueHelper;

    setup();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Card(
              elevation: 4.0,
              color: theme.cardColor,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.colorScheme.secondaryVariant,
                  ))),
          Card(
            elevation: 4.0,
            color: theme.cardColor,
            child: IconButton(
                onPressed: () {
                  saveChanges();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.done,
                  color: theme.colorScheme.secondaryVariant,
                )),
          ),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
                child: InkResponse(
              onTap: browseImage,
              child: ValueListenableBuilder<String>(
                  valueListenable: imageUrl,
                  builder: (context, image, child) {
                    if (widget.editMode) {
                      return CustomNetworkImage(
                        image,
                        backupImage: uploadImageUrl,
                        fit: BoxFit.fill,
                      );
                    }
                    return LocalImage(
                      image,
                      backupImage: uploadImageUrl,
                      fit: BoxFit.fill,
                    );
                  }),
            )),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: InformationCard(
                  label: categoryNameLabel,
                  initialValue: category.getName(),
                  onChangeConfirm: (name) {
                    if (!widget.editMode) {
                      category.setId(name);
                    }
                    category.setName(name);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
