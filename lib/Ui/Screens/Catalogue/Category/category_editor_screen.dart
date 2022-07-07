import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Category/category_editor_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_image.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_local_image.dart';
import 'package:online_order_shop_mobile/Ui/Components/cards.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class CategoryEditorScreen extends StatefulWidget {
  const CategoryEditorScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryEditorScreenState();
}

class _CategoryEditorScreenState extends State<CategoryEditorScreen> {
  late ThemeData theme;
  bool init = false;
  late CategoryEditorHelper categoryEditorHelper;

  void setup() {
    theme = Theme.of(context);
    categoryEditorHelper = Provider.of<HelpersProvider>(context, listen: false)
        .categoryEditorHelper;

    init = true;
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
                Provider.of<HelpersProvider>(context, listen: false)
                    .settingsHelper;
                Provider.of<NavigationProvider>(context, listen: false)
                    .navigateToImagePicker(
                        context, categoryEditorHelper.setImage);
              },
              child: ValueListenableBuilder<String>(
                  valueListenable: categoryEditorHelper.image,
                  builder: (context, value, child) {
                    return CustomNetworkImage(
                      value,
                      fit: BoxFit.fill,
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
