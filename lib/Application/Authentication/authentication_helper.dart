import "package:flutter/material.dart";
import 'package:online_order_shop_mobile/Application/Authentication/authentication_error_handler.dart';
import 'package:online_order_shop_mobile/Application/Orders/order_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Profile/profile_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Authentication/iauthentication_service.dart';
import 'package:online_order_shop_mobile/Infrastructure/Orders/iorder_service.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/dialogs.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

enum userData { fullName, phoneNumber, address, password, email }

class AuthenticationHelper {
  late final IAuthenticationService _authService;
  late final ProfileModel _profile;
  late final AuthenticationErrorHandler _errorHandler;
  late BuildContext _context;

  AuthenticationHelper(this._profile, this._authService, this._errorHandler);

  void setBuildContext(BuildContext context) {
    _context = context;
    _errorHandler.setBuildContext(context);
  }

  void signInWithEmailAndPassword(String email, String password) {
    _authService
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Provider.of<NavigationProvider>(_context, listen: false)
          .navigateToHomeScreen(_context);

      IOrderService orderService = ServicesProvider().orderService;

      orderService.subscribeToOrdersStream(
          Provider.of<OrdersProvider>(_context, listen: false));

      orderService.listenToOrderStreamOnServer();
      orderService.listenToOrderStatusStreamOnServer();
    }).catchError((e) {
      dev.log(e.toString());
      _errorHandler.handleErrors(e.code);
    });
  }

  void sendPasswordResetCode() {
    GlobalKey<FormState> formKey = GlobalKey();

    showDialog<AlertDialog>(
        context: _context,
        builder: (context) {
          return TextFieldAlertDialog(
            label: emailLabel,
            formKey: formKey,
            onConfirm: (String value) {
              _authService.requestNewPassword().then((value) {
                Navigator.of(context).pop();
                showDialog<AlertDialog>(
                    context: _context,
                    builder: (context) {
                      return const ErrorAlertDialog(labelNewPassword);
                    });
              });
            },
          );
        });
  }

  void updatePassword(String password) {
    _authService.confirmNewPassword(code: "code", newPassword: password);
  }

  void updateEmail(String newEmail) {
    _authService
        .updateEmail(newEmail: newEmail)
        .then((value) => {_profile.setEmail(email: newEmail)});
  }

  void logout() {
    _authService.signOut();
    ServicesProvider().orderService.cancelAllSubscribtions();
  }

  void _updateProfile(String fullName, String phone, String email) {
    _profile.setEmail(email: email);
    _profile.setFullName(fullName: fullName);

    _profile.setPhoneNumber(number: phone);
    _profile.saveProfile();
  }

  Future<void> isLoggedIn(BuildContext context) async {
    if (_authService.accountIsActive()) {
      Provider.of<NavigationProvider>(context, listen: false)
          .navigateToProfile(context);
    } else {
      Provider.of<NavigationProvider>(context, listen: false)
          .navigateToLogin(context);
    }
  }

  ProfileModel getProfile() {
    return _profile;
  }

  String getAddress() {
    return _profile.getAddress().getAddress();
  }

  void setDeliveryAddresse(BuildContext context) {
    Provider.of<NavigationProvider>(context, listen: false)
        .navigateToAddressScreen(context, () => {}, replace: false);
  }

  String getFullName() {
    return _profile.getFullName();
  }

  String getEmail() {
    return _profile.getEmail();
  }

  String getPhone() {
    return _profile.getPhoneNumber();
  }

  void saveProfile() {
    _profile.saveProfile();
  }
}
