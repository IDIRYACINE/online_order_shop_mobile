import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Category/category_manager_helper.dart';
import 'package:online_order_shop_mobile/Application/Product/product_editor_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_image.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Category category;
  final Color? backgroundColor;
  final double cardBottomPadding;
  final double dividerThickness;
  final int index;
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
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    NavigationProvider navigationHelper =
        Provider.of<NavigationProvider>(context, listen: false);

    ProductEditorHelper productManagerHelper =
        Provider.of<HelpersProvider>(context, listen: false)
            .productManagerHelper;

    CategoryManagerHelper categoryManagerHelper =
        Provider.of<HelpersProvider>(context, listen: false)
            .categoryManagerHelper;

    return Card(
      elevation: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: CustomNetworkImage(
            product.getImageUrl(),
            height: 100,
            fit: BoxFit.fitHeight,
          )),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                      child: ValueListenableBuilder<String>(
                          valueListenable: product.getNameObserver(),
                          builder: (context, name, child) {
                            return Text(name, style: theme.textTheme.bodyText1);
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            productManagerHelper.setProduct(
                                category, product, categoryManagerHelper, true);

                            navigationHelper.navigateToProductEditor(context);
                          },
                          icon: const Icon(Icons.edit_outlined)),
                      IconButton(
                          onPressed: () {
                            categoryManagerHelper.removeProduct(product);
                          },
                          icon: const Icon(Icons.remove_circle_outline)),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
