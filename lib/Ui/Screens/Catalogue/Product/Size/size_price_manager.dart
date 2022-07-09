import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Product/product_editor_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/Product/Size/product_size_price_list.dart';
import 'package:provider/provider.dart';

class SizePriceManagerScreen extends StatefulWidget {
  const SizePriceManagerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SizePriceManagerScreenState();
}

class _SizePriceManagerScreenState extends State<SizePriceManagerScreen> {
  late ThemeData theme;
  bool somethingChanged = false;
  late Product product;
  bool initiliazed = false;
  late ProductEditorHelper productManagerHelper;

  void setup(BuildContext context) {
    if (!initiliazed) {
      theme = Theme.of(context);

      productManagerHelper =
          Provider.of<HelpersProvider>(context, listen: false)
              .productManagerHelper;

      initiliazed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    setup(context);

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
                    color: theme.colorScheme.secondary,
                  ))),
          Card(
            elevation: 4.0,
            color: theme.cardColor,
            child: IconButton(
                onPressed: () {
                  productManagerHelper.applyModelsChanges();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.done,
                  color: theme.colorScheme.secondaryContainer,
                )),
          ),
        ]),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SizePriceListView(
                sizeEditorHelper: productManagerHelper.modelHelper()),
          ),
        ],
      ),
    );
  }
}
