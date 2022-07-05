import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
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
  late CatalogueHelper catalogueHelper;

  void removeProduct(Category category, int productIndex) {
    setState(() {
      catalogueHelper.removeProduct(category, productIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    catalogueHelper =
        Provider.of<HelpersProvider>(context, listen: false).catalogueHelper;

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
                      color: theme.colorScheme.secondaryVariant,
                    ))),
            Text(catalogueHelper.getCategory().getName(),
                style: theme.textTheme.headline2),
            const SizedBox()
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
                      Provider.of<NavigationProvider>(context, listen: false)
                          .navigateToProductDetails(
                              context,
                              catalogueHelper.getCategory(),
                              Product("", "", "", [], []));
                    },
                    icon: const Icon(Icons.add_circle_outline)),
              ],
            )),
            Expanded(
                flex: golenRationFlexSmall,
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: catalogueHelper.getCategory().getProductCount(),
                  itemBuilder: (context, productIndex) => catalogueHelper
                      .productWidgetBuilder(context, productIndex,
                          (category, productIndex) {
                    removeProduct(category, productIndex);
                  }),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
