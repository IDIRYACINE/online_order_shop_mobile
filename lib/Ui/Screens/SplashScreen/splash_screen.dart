import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ConstrainedBox(
                constraints:
                    BoxConstraints.loose(const Size(double.infinity, 200)),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.scaleDown,
                ),
              )
            ],
          ),
        ));
  }
}
