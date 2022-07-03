import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Authentication/authentication_helper.dart';
import 'package:online_order_shop_mobile/Application/Authentication/user_input_validator.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/buttons.dart';
import 'package:online_order_shop_mobile/Ui/Components/forms.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final double runSpacing = 8.0;
  final dividerThickness = 2.0;

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  String email = "";
  String password = "";

  void onEmailChanged(String value) {
    email = value;
  }

  void onPasswordChanged(String value) {
    password = value;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AuthenticationHelper _authenticationHelper =
        Provider.of<HelpersProvider>(context, listen: false).authHelper;

    _authenticationHelper.setBuildContext(context);

    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.center,
              image: AssetImage("assets/images/food.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(spaceDefault),
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderCircularRaduisLarge),
                  topRight: Radius.circular(borderCircularRaduisLarge),
                )),
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextFormField(
                      label: emailLabel,
                      hint: emailHint,
                      onChange: onEmailChanged,
                      validator: UserInputValidtor.validateEmail,
                    ),
                    CustomTextFormField(
                      label: passwordLabel,
                      hint: passwordHint,
                      obsecureText: true,
                      trailing: TextButton(
                          onPressed: () {
                            _authenticationHelper.sendPasswordResetCode();
                          },
                          child: Text(
                            labelForgotPassword,
                            style: theme.textTheme.overline,
                          )),
                      onChange: onPasswordChanged,
                    ),
                    DefaultButton(
                      text: loginLabel,
                      width: double.infinity,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _authenticationHelper.signInWithEmailAndPassword(
                              email, password);
                        }
                      },
                    ),
                    const SizedBox(height: 50)
                  ]),
            )),
      ],
    ));
  }
}
