import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/category_manager_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/local_image.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_local_image.dart';
import 'package:online_order_shop_mobile/Ui/Components/cards.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class CategoryManagerScreen extends StatefulWidget {
  const CategoryManagerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends State<CategoryManagerScreen> {
  late CatalogueHelper catalogueHelper;
  late CategoryManagerHelper categoryManagerHelper;
  late ThemeData theme;
  bool init = false;

  void setup() {
    if (!init) {
      categoryManagerHelper =
          Provider.of<HelpersProvider>(context, listen: false)
              .categoryManagerHelper;

      theme = Theme.of(context);

      catalogueHelper =
          Provider.of<HelpersProvider>(context, listen: false).catalogueHelper;

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
                  categoryManagerHelper.applyChanges();
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
                categoryManagerHelper.browseImage();
              },
              child: ValueListenableBuilder<String>(
                  valueListenable: categoryManagerHelper.image,
                  builder: (context, value, child) {
                    return NetworkLocalImage(
                      value,
                      fit: BoxFit.fill,
                      firstLoadWatcher: categoryManagerHelper.firstLoad,
                    );
                  }),
            )),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: InformationCard(
                  label: categoryNameLabel,
                  initialValue: categoryManagerHelper.name,
                  onChangeConfirm: categoryManagerHelper.setName,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
