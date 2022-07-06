import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/Category/category_manager_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart';
import 'package:online_order_shop_mobile/Ui/Components/Dialogs/confirmation_dialog.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_image.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  final Category category;
  final int thumbnailFlex = 3;
  final int contentFlex = 3;
  final int actionsFLex = 1;
  final int index;
  const CategoryWidget(this.category, {Key? key, required this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late NavigationProvider navigationHelper;
  late CategoryManagerHelper categoryManagerHelper;
  late CatalogueHelper catalogueHelper;
  late ThemeData theme;

  bool init = false;

  void setup() {
    categoryManagerHelper = Provider.of<HelpersProvider>(context, listen: false)
        .categoryManagerHelper;

    theme = Theme.of(context);

    navigationHelper = Provider.of<NavigationProvider>(context, listen: false);

    catalogueHelper =
        Provider.of<HelpersProvider>(context, listen: false).catalogueHelper;

    init = true;
  }

  @override
  Widget build(BuildContext context) {
    setup();

    return InkResponse(
      onTap: () {
        categoryManagerHelper.setCategory(widget.category);
        navigationHelper.navigateToCategoryManager(context);
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
                    ValueListenableBuilder<String>(
                        valueListenable: widget.category.getNameObserver(),
                        builder: (context, name, child) {
                          return Text(name, style: theme.textTheme.bodyText1);
                        }),
                    const SizedBox(height: 4.00),
                    ValueListenableBuilder<int>(
                      valueListenable:
                          widget.category.getProductCountObserver(),
                      builder: (context, count, child) {
                        return Text(
                          'Articles : ${count.toString()}',
                          style: theme.textTheme.bodyText2,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Provider.of<HelpersProvider>(context, listen: false)
                      .categoryEditorHelper
                      .setCategory(widget.category);
                  navigationHelper.navigateToCategoryEditor(context);
                },
                icon: const Icon(Icons.edit_outlined)),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                  onPressed: () {
                    showDialog<AlertDialog>(
                        context: context,
                        builder: (context) {
                          return ConfirmAlertDialog(
                            onConfirm: () {
                              catalogueHelper.removeCategory(widget.category);
                            },
                            message: messagePermanantAction,
                          );
                        });
                  },
                  icon: const Icon(Icons.remove_circle_outline)),
            ),
          ],
        ),
      ),
    );
  }
}
