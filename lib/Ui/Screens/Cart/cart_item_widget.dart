import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Cart/cart_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Cart/cart_item.dart';
import 'package:online_order_shop_mobile/Ui/Components/forms.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;
  final int thumbnailFlex = 3;
  final int contentFlex = 3;
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
        children: [
          Expanded(
              flex: widget.thumbnailFlex,
              child: FaultTolerantImage(
                widget.cartItem.getThumbnailUrl(),
                height: double.maxFinite,
                fit: BoxFit.fitHeight,
              )),
          Expanded(
              flex: widget.contentFlex,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.cartItem.getName(),
                        style: theme.textTheme.headline2),
                    Text(
                      widget.cartItem.getPrice().toString(),
                      style: theme.textTheme.headline2,
                    )
                  ],
                ),
              )),
          Expanded(
              flex: widget.actionsFLex,
              child: Text(widget.cartItem.getQuantity().toString()))
        ],
      ),
    );
  }
}
