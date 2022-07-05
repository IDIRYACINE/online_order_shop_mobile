import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Cart/cart_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Cart/cart_item.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_image.dart';
import 'package:online_order_shop_mobile/Ui/Components/forms.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;
  final int thumbnailFlex = 1;
  final int contentFlex = 2;
  final int actionsFLex = 1;
  const CartItemWidget(this.cartItem, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CartItemState();
}

class _CartItemState extends State<CartItemWidget> {
  late NavigationProvider navigationHelper;
  late CartHelper cartHelper;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    navigationHelper = Provider.of<NavigationProvider>(context, listen: false);
    cartHelper =
        Provider.of<HelpersProvider>(context, listen: false).cartHelper;

    return Card(
      elevation: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 2,
              child: CustomNetworkImage(
                widget.cartItem.getThumbnailUrl(),
                height: double.maxFinite,
                fit: BoxFit.fitHeight,
              )),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.cartItem.getName(),
                        style: theme.textTheme.bodyText1),
                    Text(
                      '${widget.cartItem.getPrice().toString()} $labelCurrency x${widget.cartItem.getQuantity().toString()}',
                      style: theme.textTheme.bodyText2,
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
