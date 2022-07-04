import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'package:online_order_shop_mobile/Domain/Orders/order_status.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/buttons.dart';
import 'package:online_order_shop_mobile/Ui/Components/dialogs.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

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
    ThemeData theme = Theme.of(context);

    void updateState(String newState) {
      ServicesProvider().orderService.updateOrderStatus(
          OrderStatus.frToEnStatus(newState), widget.order.getId());
    }

    return InkResponse(
      onTap: () {
        showDialog<AlertDialog>(
            context: context,
            builder: (context) {
              return SpinnerAlertDialog(
                  data: OrderStatus.values, onConfirm: updateState);
            });
      },
      child: Card(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            child: Text(widget.order.getCustomerName()),
          ),
          Expanded(
            child: TextButton(
              child: const Text(deleteOrderLabel),
              onPressed: () {
                ServicesProvider()
                    .orderService
                    .deleteOrder(widget.order.getId());
              },
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                Provider.of<NavigationProvider>(context, listen: false)
                    .navigateToOrderDetails(context, widget.order);
              },
              child: Text(
                buttonOrderDetails,
                style: theme.textTheme.overline,
              ),
            ),
          )
        ]),
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