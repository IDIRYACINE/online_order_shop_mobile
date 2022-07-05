import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Infrastructure/Exceptions/auth_exceptions.dart';
import 'package:online_order_shop_mobile/Ui/Components/Dialogs/dialogs.dart';

class AuthenticationErrorHandler {
  late BuildContext _context;

  void setBuildContext(BuildContext context) {
    _context = context;
  }

  void showErrorDialog(String message) {
    showDialog<AlertDialog>(
        context: _context,
        builder: (context) {
          return ErrorAlertDialog(message);
        });
  }

  void handleErrors(String code) {
    switch (code) {
      case InvalidLoginInfos.errorCode:
        showErrorDialog(InvalidLoginInfos.errorMessage);
        break;
      case EmailAlreadyUsed.errorCode:
        showErrorDialog(InvalidLoginInfos.errorMessage);
        break;
      case InvalidEmail.errorCode:
        showErrorDialog(InvalidEmail.errorMessage);
        break;
      case WeakPassword.errorCode:
        showErrorDialog(WeakPassword.errorMessage);
        break;
      default:
        showErrorDialog(UnexpectedError.errorMessage);
    }
  }
}
