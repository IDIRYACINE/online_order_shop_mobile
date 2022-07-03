import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Authentication/authentication_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'package:online_order_shop_mobile/Ui/Components/buttons.dart';
import 'package:online_order_shop_mobile/Ui/Components/cards.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class OrderDetaillsScreen extends StatefulWidget {
  final IOrder order;
  final double cardsPadding = 10.0;

  final double verticalDividerThickness = 5.0;
  final double verticalDividerHeight = 150;

  const OrderDetaillsScreen(
    this.order, {
    Key? key,
  }) : super(key: key);

  @override
  State<OrderDetaillsScreen> createState() => _OrderDetaillsScreentState();
}

class _OrderDetaillsScreentState extends State<OrderDetaillsScreen> {
  @override
  Widget build(BuildContext context) {
    AuthenticationHelper _authHelper =
        Provider.of<HelpersProvider>(context, listen: false).authHelper;

    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.surface,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Card(
              elevation: 4.0,
              color: theme.cardColor,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.colorScheme.primary,
                  ))),
          Text(profileTitle, style: theme.textTheme.headline2),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(widget.cardsPadding),
                child: InformationCard(
                  label: usernameLabel,
                  initialValue: widget.order.getCustomerName(),
                  onPressed: () {},
                  onChangeConfirm: (String value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.all(widget.cardsPadding),
                child: InformationCard(
                  label: emailLabel,
                  initialValue: widget.order.getEmail(),
                  onPressed: () {},
                  onChangeConfirm: (String value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.all(widget.cardsPadding),
                child: InformationCard(
                  label: addressLabel,
                  initialValue: widget.order.getAddress(),
                  onPressed: () {},
                  onChangeConfirm: (String value) {},
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(widget.cardsPadding),
                  child: InformationCard(
                    label: addressLabel,
                    initialValue: _authHelper.getAddress(),
                    onPressed: () {
                      _authHelper.setDeliveryAddresse(context);
                    },
                    onChangeConfirm: (value) {},
                  )),
              Padding(
                padding: EdgeInsets.all(widget.cardsPadding),
                child: InformationCard(
                  label: cartItemsCountLabel,
                  initialValue: widget.order.getItemsCount().toString(),
                  onPressed: () {},
                  onChangeConfirm: (String value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.all(widget.cardsPadding),
                child: InformationCard(
                  label: cartTotalPrice,
                  initialValue: widget.order.getTotalPrice().toString(),
                  onPressed: () {},
                  onChangeConfirm: (String value) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
                fontSize: textSizeMeduim,
                color: color,
                fontWeight: FontWeight.bold),
          ),
          if (widget.description != null)
            Text(
              widget.description!,
              style: theme.textTheme.subtitle2,
            )
        ],
      ))
*/      