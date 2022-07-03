import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Cart/cart_item.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
import 'package:online_order_shop_mobile/Ui/Components/forms.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Category category;
  final Color? backgroundColor;
  final double cardBottomPadding;
  final double dividerThickness;
  final double productNameTopPadding;
  final int imageFlex = 2;
  final double cardElevation = 8.0;

  const ProductWidget(
    this.category,
    this.product, {
    Key? key,
    this.backgroundColor,
    this.dividerThickness = 4,
    this.productNameTopPadding = 4,
    this.cardBottomPadding = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    NavigationProvider navigation = Provider.of<NavigationProvider>(context);

    return InkResponse(
      onTap: () {
        navigation.navigateToProductDetails(context, category, product);
      },
      child: Card(
          color: backgroundColor ?? theme.cardColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderCircularRaduis)),
          elevation: cardElevation,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: imageFlex,
                child: FaultTolerantImage(
                  product.getImageUrl(),
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                  child: Center(
                child:
                    Text(product.getName(), style: theme.textTheme.headline2),
              )),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: cardBottomPadding),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.getPrice().toString(),
                          style: theme.textTheme.headline2,
                        ),
                        const Text(
                          labelCurrency,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              ),
            ],
          )),
    );
  }
}
