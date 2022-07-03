import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/optional_item.dart';
import 'package:online_order_shop_mobile/Ui/Components/category_widget.dart';
import 'package:online_order_shop_mobile/Ui/Components/product_components.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class CatalogueScreen extends StatefulWidget {
  final double bodyPadding = 16.0;
  final double fixedCategoryWidth = 100;
  final double spaceBetweenProducts = 10.0;
  final int categoriesScrollerFlex = 1;
  final int productsScrollerFlex = 2;
  final int previewHeaderFlex = 1;
  final int previewBodyFlex = 9;
  final int productsFlex = 1;
  const CatalogueScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  late CatalogueHelper catalogueHelper;
  late NavigationProvider navigationProvider;

  void onCategoryPressed(int index, VoidCallback toggleSelfCallback) {
    catalogueHelper.setSelectedCategory(index);
    // Rebuilding widget will cancel the execution of the function ! ValueNotifiers
  }

  void removeCategory(int index) {
    setState(() {
      catalogueHelper.removeCategory(index);
    });
  }

  void onSeeAllPressed(BuildContext context) {
    navigationProvider.navigateToCategory(context);
  }

  @override
  Widget build(BuildContext context) {
    catalogueHelper =
        Provider.of<HelpersProvider>(context, listen: false).catalogueHelper;
    navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);

    final ThemeData theme = Theme.of(context);

    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(widget.bodyPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categoriesTitle,
                      style: theme.textTheme.headline6,
                    ),
                    IconButton(
                        onPressed: () {
                          navigationProvider.navigateToCategoryManager(context);
                        },
                        icon: const Icon(Icons.add_circle_outline)),
                  ],
                )),
                Expanded(
                    flex: golenRationFlexSmall,
                    child: ListView.separated(
                      itemCount: catalogueHelper.getCategoriesCount(),
                      itemBuilder: (context, index) {
                        return CategoryWidget(
                            catalogueHelper.getCategory(index),
                            removeCategory: removeCategory,
                            index: index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                    )),
              ],
            )));
  }
}
