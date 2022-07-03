import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/bottom_nav_bar.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context);

    HelpersProvider helpersProvider = Provider.of<HelpersProvider>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appTitle, style: theme.textTheme.headline2),
            ],
          ),
        ),
        body: navigationProvider.getScreen(),
        bottomNavigationBar: const BottomNavBar());
  }
}
