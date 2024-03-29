import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_order_shop_mobile/Application/Orders/order_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Infrastructure/Orders/iorder_service.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/Dialogs/error_dialog.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Login/login_screen.dart';
import 'package:online_order_shop_mobile/Ui/Screens/SplashScreen/splash_screen.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:online_order_shop_mobile/Ui/Themes/main_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NavigationProvider()),
    ChangeNotifierProvider(create: (_) => HelpersProvider()),
    ChangeNotifierProvider(create: (_) => OrdersProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HelpersProvider _helpers = Provider.of<HelpersProvider>(context);
    return GetMaterialApp(
        theme: primaryTheme,
        home: FutureBuilder(
          future: _helpers.initApp(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              if (ServicesProvider().authenticationService.accountIsActive()) {
                IOrderService orderService = ServicesProvider().orderService;
                orderService.subscribeToOrdersStream(
                    Provider.of<OrdersProvider>(context, listen: false));

                orderService.listenToOrderStreamOnServer();
                orderService.listenToOrderStatusStreamOnServer();

                return Provider.of<NavigationProvider>(context, listen: false)
                    .getHomeScreen();
              }
              return const LoginScreen();
            }
            if (snapshot.hasError) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const ErrorAlertDialog(labelError);
                  });
              return const SplashScreen();
            } else {
              return const SplashScreen();
            }
          },
        ));
  }
}
