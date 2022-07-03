import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
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

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

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
        ]),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SizePriceListView(
              price: widget.product.getPriceList(),
              size: widget.product.getSizeList(),
            ),
          ),
        ],
      ),
    );
  }
}
