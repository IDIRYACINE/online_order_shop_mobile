import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Cart/cart.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'package:online_order_shop_mobile/Domain/Orders/order_status.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/Dialogs/spinner_dialog.dart';
import 'package:online_order_shop_mobile/Ui/Components/cards.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

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
  void dialPhone() {
    url_launcher
        .launchUrl(Uri(scheme: 'tel', path: widget.order.getPhoneNumber()));
  }

  void updateState(String newState) {
    ServicesProvider().orderService.updateOrderStatus(
        OrderStatus.frToEnStatus(newState), widget.order.getId());
  }

  @override
  Widget build(BuildContext context) {
    NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);

    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                    color: theme.colorScheme.secondaryVariant,
                  ))),
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
                  label: phoneLabel,
                  initialValue: widget.order.getPhoneNumber(),
                  onPressed: () {
                    dialPhone();
                  },
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
                  onPressed: () {
                    navigationProvider.navigateToDeliveryAddressScreen(context,
                        latitude: widget.order.getLatitude(),
                        longitude: widget.order.getLongitude());
                  },
                  onChangeConfirm: (String value) {},
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(widget.cardsPadding),
                  child: InformationCard(
                      label: orderStatusLabel,
                      initialValue: widget.order.getStatus(),
                      onPressed: () {
                        showDialog<AlertDialog>(
                            context: context,
                            builder: (context) {
                              return SpinnerAlertDialog(
                                  data: OrderStatus.values,
                                  initialValue: widget.order.getStatus(),
                                  onConfirm: updateState);
                            });
                      },
                      onChangeConfirm: (String value) {})),
              Padding(
                padding: EdgeInsets.all(widget.cardsPadding),
                child: InformationCard(
                  label: cartItemsCountLabel,
                  initialValue: widget.order.getItemsCount().toString(),
                  onPressed: () {
                    navigationProvider.navigateToCart(
                        context, Cart(widget.order));
                  },
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
