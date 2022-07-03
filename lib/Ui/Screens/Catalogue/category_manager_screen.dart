import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/forms.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

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

  void saveChanges() {
    if (widget.editMode) {
      category.transfer(widget.category!);
      catalogueHelper.updateCategory(category);
      ServicesProvider().serverAcessService.addFileToUploadQueue(
          fileUrl: category.getImageUrl(), savePath: category.getId());
      return;
    }
    catalogueHelper.createCategory(category);
  }

  void setup() {
    if (widget.editMode == false) {
      category = Category(
        id: '',
        name: '',
        productsCount: 0,
        imageUrl: uploadImageUrl,
      );
      return;
    }
    category = Category.from(widget.category!);
  }

  Future<void> browseImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      category.setImageUrl(image.path);
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
      body: Column(
        children: [
          Flexible(
              child: InkResponse(
            onTap: browseImage,
            child: FaultTolerantImage(
              category.getImageUrl(),
              backupImage: uploadImageUrl,
              fit: BoxFit.fill,
            ),
          )),
          Flexible(
              child: CustomTextFormField(
            label: categoryNameLabel,
            initialValue: category.getName(),
            onChange: (value) {},
          )),
        ],
      ),
    );
  }
}
