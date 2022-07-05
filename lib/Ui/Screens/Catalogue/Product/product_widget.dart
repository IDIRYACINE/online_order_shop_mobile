import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_image.dart';
import 'package:provider/provider.dart';

typedef ProductCallback = void Function(Category category, int product);

class ProductWidget extends StatelessWidget {
  final Product product;
  final Category category;
  final Color? backgroundColor;
  final double cardBottomPadding;
  final double dividerThickness;
  final int index;
  final double productNameTopPadding;
  final int imageFlex = 2;
  final ProductCallback removeProduct;
  final double cardElevation = 8.0;

  const ProductWidget(
    this.category,
    this.product, {
    Key? key,
    this.backgroundColor,
    this.dividerThickness = 4,
    this.productNameTopPadding = 4,
    this.cardBottomPadding = 10,
    required this.removeProduct,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    NavigationProvider navigationHelper =
        Provider.of<NavigationProvider>(context);

    return InkResponse(
      onTap: () {
        navigationHelper.navigateToProductDetails(context, category, product);
      },
      child: Card(
        elevation: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: CustomNetworkImage(
              product.getImageUrl(),
              height: double.maxFinite,
              fit: BoxFit.fitHeight,
            )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                        child: Text(product.getName(),
                            style: theme.textTheme.bodyText1),
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
                              navigationHelper.navigateToProductDetails(
                                  context, category, product, true);
                            },
                            icon: const Icon(Icons.edit_outlined)),
                        IconButton(
                            onPressed: () {
                              removeProduct(category, index);
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
      ),
    );
  }
}
