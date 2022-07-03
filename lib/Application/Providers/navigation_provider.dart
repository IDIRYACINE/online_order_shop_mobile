import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/catalogue_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/category_manager_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/category_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/product_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/size_price_manager.dart';
import 'package:online_order_shop_mobile/Ui/Screens/DeliveryAddress/gps_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Orders/order_detaills.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Orders/orders_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Profile/profile_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Settings/settings_screen.dart';
import 'package:online_order_shop_mobile/home_screen.dart';

class NavigationProvider with ChangeNotifier {
  final List<Widget> _screens = [
    const SettingsScreen(),
    const CatalogueScreen(),
    const OrdersScreen()
  ];

  int _screenIndex = 1;
  int _iconIndex = 0;

  NavigationProvider();

  Widget getScreen() => _screens[_screenIndex];

  void navigateToCart() {
    _screenIndex = 0;
    _iconIndex = 2;
    notifyListeners();
  }

  void navigateToCatalogue() {
    _screenIndex = 1;
    _iconIndex = 0;
    notifyListeners();
  }

  void navigateToStatusScreen() {
    _screenIndex = 2;
    _iconIndex = 1;
    notifyListeners();
  }

  void navigateToSettings() {}

  void navigateToLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void navigateToStatus(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const OrdersScreen()));
  }

  void navigateToDeliveryAddressScreen(
      BuildContext context, VoidCallback callback,
      {required bool replace}) {
    if (!replace) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DeliveryAddresScreen(callback)));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DeliveryAddresScreen(callback)));
    }
  }

  void navigateToProfile(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void navigateToCategory(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CategoryScreen()));
  }

  void navigateToProductDetails(
      BuildContext context, Category category, Product product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsScreen(product, category: category)));
  }

  void navigateToOrderDetails(BuildContext context, IOrder order) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => OrderDetaillsScreen(order)));
  }

  int getScreenIndex() {
    return _screenIndex;
  }

  int getIconIndex() {
    return _iconIndex;
  }

  void navigateToCategoryManager(BuildContext context,
      [bool editMode = false, Category? category]) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryManagerScreen(
                  editMode: editMode,
                  category: category,
                )));
  }

  void navigateToSizeManager(BuildContext context, Product product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SizePriceManagerScreen(product: product)));
  }
}
