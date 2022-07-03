import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'package:online_order_shop_mobile/Ui/Components/buttons.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

class OrderWidget extends StatefulWidget {
  final IOrder order;

  final double verticalDividerThickness = 5.0;
  final double verticalDividerHeight = 150;

  const OrderWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    //ThemeData theme = Theme.of(context);

    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Flexible(
        child: Text(widget.order.getCustomerName()),
      ),
      const Flexible(child: Spacer()),
      const Expanded(child: DefaultButton(text: buttonOrderDetails))
    ]);
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