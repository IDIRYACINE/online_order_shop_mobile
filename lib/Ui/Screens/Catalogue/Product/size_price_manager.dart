import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/product_size_price_list.dart';

class SizePriceManagerScreen extends StatefulWidget {
  final Product product;
  const SizePriceManagerScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SizePriceManagerScreenState();
}

class _SizePriceManagerScreenState extends State<SizePriceManagerScreen> {
  late ThemeData theme;
  bool somethingChanged = false;
  late Product product;
  bool initiliazed = false;

  void saveChanges() {
    if (somethingChanged) {
      IProductsDatabase productsDatabase = ServicesProvider().productDatabase;
      productsDatabase.remebmerChange();

      product.transfer(widget.product);
    }
  }

  void registerChange() {
    somethingChanged = true;
  }

  void setup() {
    if (!initiliazed) {
      product = Product.from(widget.product);
      initiliazed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
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
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SizePriceListView(
              prices: product.getPriceList(),
              sizes: product.getSizeList(),
              onChange: registerChange,
            ),
          ),
        ],
      ),
    );
  }
}
