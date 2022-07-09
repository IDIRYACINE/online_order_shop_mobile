import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Category/category_manager_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final int gridCrossAxisCount = 2;
  final double gridCrossAxisSpacing = spaceDefault;
  final double gridMainAxisSpacing = 5.0;
  final double bodyPadding = 16.0;

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late CategoryManagerHelper categoryManagerHelper;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    categoryManagerHelper = Provider.of<HelpersProvider>(context, listen: false)
        .categoryManagerHelper;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              elevation: 4.0,
              color: theme.cardColor,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: theme.colorScheme.secondaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
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
                  productsTitle,
                  style: theme.textTheme.headline2,
                ),
                IconButton(
                    onPressed: () {
                      Category category = categoryManagerHelper.getCategory();
                      Provider.of<HelpersProvider>(context, listen: false)
                          .productManagerHelper
                          .setProduct(
                              category,
                              Product("", "", "", [0], ["Standard"],
                                  category.getProductCount() + 1),
                              categoryManagerHelper,
                              false);

                      Provider.of<NavigationProvider>(context, listen: false)
                          .navigateToProductEditor(context);
                    },
                    icon: const Icon(Icons.add_circle_outline)),
              ],
            )),
            Expanded(
                flex: golenRationFlexSmall,
                child: ValueListenableBuilder<int>(
                    valueListenable: categoryManagerHelper.productCount,
                    builder: (context, itemCount, child) {
                      return ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemCount: itemCount,
                        itemBuilder: (context, productIndex) =>
                            categoryManagerHelper.productWidgetBuilder(
                          context,
                          productIndex,
                        ),
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
