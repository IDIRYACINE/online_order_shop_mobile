import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Ui/Screens/SplashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

class RebootScreen extends StatelessWidget {
  final AsyncCallback task;

  const RebootScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    task().then((value) =>
        Provider.of<NavigationProvider>(context, listen: false)
            .navigateToHomeScreen(context));

    return const SplashScreen();
  }
}
