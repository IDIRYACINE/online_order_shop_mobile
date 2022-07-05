import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Cart/cart_helper.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_image.dart';
import 'package:provider/provider.dart';

typedef IntegerCallback = void Function(int index);

class CategoryWidget extends StatefulWidget {
  final Category category;
  final int thumbnailFlex = 3;
  final int contentFlex = 3;
  final int actionsFLex = 1;
  final int index;
  final IntegerCallback removeCategory;
  const CategoryWidget(this.category,
      {Key? key, required this.removeCategory, required this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late NavigationProvider navigationHelper;
  late CartHelper cartHelper;
  late CatalogueHelper catalogueHelper;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    navigationHelper = Provider.of<NavigationProvider>(context, listen: false);
    cartHelper =
        Provider.of<HelpersProvider>(context, listen: false).cartHelper;

    catalogueHelper =
        Provider.of<HelpersProvider>(context, listen: false).catalogueHelper;

    return InkResponse(
      onTap: () {
        catalogueHelper.setSelectedCategory(widget.category);
        navigationHelper.navigateToCategory(context);
      },
      child: Card(
        elevation: 4.0,
        child: Row(
          children: [
            Expanded(
                child: CustomNetworkImage(
              widget.category.getImageUrl(),
              height: 100,
            )),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.category.getName(),
                        style: theme.textTheme.bodyText1),
                    const SizedBox(height: 4.00),
                    Text(
                      'Articles : ${widget.category.getProductCount().toString()}',
                      style: theme.textTheme.bodyText2,
                    )
                  ],
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  catalogueHelper.setSelectedCategory(widget.category);
                  navigationHelper.navigateToCategoryManager(
                      context, widget.category, true);
                },
                icon: const Icon(Icons.edit_outlined)),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                  onPressed: () {
                    widget.removeCategory(widget.index);
                  },
                  icon: const Icon(Icons.remove_circle_outline)),
            ),
          ],
        ),
      ),
    );
  }
}
