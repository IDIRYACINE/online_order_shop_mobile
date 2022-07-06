import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Category/category_editor_helper.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_local_image.dart';
import 'package:online_order_shop_mobile/Ui/Components/cards.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

class CategoryEditorScreen extends StatefulWidget {
  final Category category;
  const CategoryEditorScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryEditorScreenState();
}

class _CategoryEditorScreenState extends State<CategoryEditorScreen> {
  late ThemeData theme;
  bool init = false;
  late CategoryEditorHelper categoryEditorHelper;

  void setup() {
    if (!init) {
      theme = Theme.of(context);
      categoryEditorHelper = CategoryEditorHelper(widget.category);

      init = true;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  categoryEditorHelper.applyChanges();
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
              onTap: () {
                categoryEditorHelper.browseImage();
              },
              child: ValueListenableBuilder<String>(
                  valueListenable: categoryEditorHelper.image,
                  builder: (context, value, child) {
                    return NetworkLocalImage(
                      value,
                      fit: BoxFit.fill,
                      firstLoadWatcher: categoryEditorHelper.firstLoad,
                    );
                  }),
            )),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: InformationCard(
                  label: categoryNameLabel,
                  initialValue: categoryEditorHelper.name,
                  onChangeConfirm: categoryEditorHelper.setName,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
