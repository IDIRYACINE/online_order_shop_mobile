import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Cart/cart_helper.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/category_manager_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
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
  late CartHelper cartHelper;
  late CategoryManagerHelper categoryManagerHelper;
  late ThemeData theme;
  bool init = false;

  void setup() {
    if (!init) {
      categoryManagerHelper =
          Provider.of<HelpersProvider>(context, listen: false)
              .categoryManagerHelper;

      theme = Theme.of(context);

      navigationHelper =
          Provider.of<NavigationProvider>(context, listen: false);

      cartHelper =
          Provider.of<HelpersProvider>(context, listen: false).cartHelper;

      init = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    setup();

    return InkResponse(
      onTap: () {
        categoryManagerHelper.setCategory(widget.category, false);
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
                  categoryManagerHelper.setCategory(widget.category);

                  navigationHelper.navigateToCategoryManager(context);
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
                              categoryManagerHelper
                                  .removeCategory(widget.category);
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
