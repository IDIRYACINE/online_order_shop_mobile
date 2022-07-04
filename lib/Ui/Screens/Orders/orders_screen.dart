import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Orders/order_helper.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Orders/order_widget.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    OrdersProvider ordersProvider = Provider.of<OrdersProvider>(context);

    ValueNotifier<int> selectedTabIndex =
        ValueNotifier<int>(ordersProvider.selectedTabIndex);

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DefaultTabController(
            initialIndex: selectedTabIndex.value,
            length: 3,
            child: Scaffold(
                body: Column(
              children: [
                Flexible(
                  child: TabBar(
                    onTap: (index) {
                      selectedTabIndex.value = index;
                      ordersProvider.setSelectedTabIndex(index);
                    },
                    tabs: [
                      Tab(
                          child: Text(
                        waitingTab,
                        style: theme.textTheme.bodyText1,
                      )),
                      Tab(
                          child: Text(confirmedTab,
                              style: theme.textTheme.bodyText1)),
                      Tab(
                          child: Text(deliveryTab,
                              style: theme.textTheme.bodyText1)),
                    ],
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<int>(
                      valueListenable: selectedTabIndex,
                      builder: (context, value, child) {
                        return ListView.builder(
                            itemCount: ordersProvider
                                .getOrdersCount(selectedTabIndex.value),
                            itemBuilder: (context, index) {
                              IOrder order = ordersProvider.getOrder(
                                  selectedTabIndex.value, index);
                              return OrderWidget(order: order);
                            });
                      }),
                )
              ],
            ))));
  }
}
