import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context);

    return BottomNavigationBar(
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.secondaryVariant,
        iconSize: 30,
        currentIndex: navigationProvider.getIconIndex(),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                navigationProvider.navigateToCatalogue();
              },
              icon: const Icon(Icons.home),
            ),
            label: bottomNavBarHome,
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                navigationProvider.navigateToStatusScreen();
              },
              icon: const Icon(Icons.notifications),
            ),
            label: bottomNavBarOrders,
          ),
          BottomNavigationBarItem(
            label: bottomNavBarCart,
            icon: IconButton(
                onPressed: () {
                  navigationProvider.navigateToSettings();
                },
                icon: const Icon(Icons.settings)),
          )
        ]);
  }
}
