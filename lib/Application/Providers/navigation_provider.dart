import 'package:flutter/foundation.dart';
import 'package:online_order_shop_mobile/Domain/Cart/cart.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Category/category_model.dart'
    as my_app;
import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';
import 'package:online_order_shop_mobile/Domain/Orders/iorder.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Cart/cart_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/Category/category_editor_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/Category/category_manager_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/Product/product_manager_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/Product/Size/size_price_manager.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Catalogue/catalogue_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/DeliveryAddress/gps_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/DeliveryAddress/immutable_map.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Orders/order_detaills.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Orders/orders_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Profile/profile_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Settings/settings_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/SplashScreen/reboot_screen.dart';
import 'package:online_order_shop_mobile/home_screen.dart';

class NavigationProvider with ChangeNotifier {
  final List<Widget> _screens = [
    const SettingsScreen(),
    const CatalogueScreen(),
    const OrdersScreen()
  ];

  Widget? _homeScreen;

  int _screenIndex = 1;
  int _iconIndex = 0;

  NavigationProvider();

  Widget getHomeScreen() {
    _homeScreen ??= const HomeScreen();

    return _homeScreen!;
  }

  Widget getScreen() => _screens[_screenIndex];

  void navigateToSettings() {
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

  void navigateToCart(BuildContext context, Cart cart) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CartScreen(cart)));
  }

  void navigateToLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void navigateToStatus(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const OrdersScreen()));
  }

  void navigateToDeliveryAddressScreen(BuildContext context,
      {required double latitude, required double longitude}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImmutableDeliveryAddresScreen(
                  latitude: latitude,
                  longitude: longitude,
                )));
  }

  void navigateToProfile(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void navigateToRebootScreen(BuildContext context, AsyncCallback task) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RebootScreen(
                  task: task,
                )));
  }

  void navigateToCategoryManager(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CategoryScreen()));
  }

  void navigateToProductDetails(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProductsScreen()));
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

  void navigateToCategoryEditor(
      BuildContext context, my_app.Category category) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryEditorScreen(
                  category: category,
                )));
  }

  void navigateToSizeManager(BuildContext context, Product product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SizePriceManagerScreen()));
  }

  void navigateToAddressScreen(BuildContext context, VoidCallback callback,
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
}
