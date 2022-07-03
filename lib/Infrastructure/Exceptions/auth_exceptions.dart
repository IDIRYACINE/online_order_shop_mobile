import 'custom_exception.dart';

class InvalidLoginInfos extends CustomException {
  static const errorCode = "invalid-login";
  static const errorMessage = "Incorrect password or email";

  InvalidLoginInfos(
      {String code = errorCode,
      String message = errorMessage,
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class InvalidVerificationCode extends CustomException {
  static const errorCode = "invalid-code";
  static const errorMessage = "Incorrect verification code";

  InvalidVerificationCode(
      {String code = errorCode,
      String message = errorMessage,
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class EmailAlreadyUsed extends CustomException {
  static const errorCode = "used-email";
  static const errorMessage =
      "Email already used , try requesting validation email";

  EmailAlreadyUsed(
      {String code = errorCode,
      String message = errorMessage,
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class InvalidUser extends CustomException {
  static const errorCode = "invalid-user";
  static const errorMessage = "User doesn't exist";

  InvalidUser(
      {String code = errorCode,
      String message = errorMessage,
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class InvalidEmail extends CustomException {
  static const errorCode = "invalid-email";
  static const errorMessage = "Invalid email";

  InvalidEmail(
      {String code = errorCode,
      String message = errorMessage,
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class WeakPassword extends CustomException {
  static const errorCode = "invalid-password";
  static const errorMessage = "Invalid phone number";

  WeakPassword(
      {String code = errorCode,
      String message = "Password should be at least 8 characters long",
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class InvalidNumber extends CustomException {
  static const errorCode = "invalid-phone";
  static const errorMessage = "Invalid phone number";

  InvalidNumber(
      {String code = errorCode,
      String message = errorMessage,
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class AccountAlreadyLinked extends CustomException {
  static const errorCode = "account-already-linked";
  static const errorMessage = "Account already linked";

  AccountAlreadyLinked(
      {String code = errorCode,
      String message = errorMessage,
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class UnexpectedError extends CustomException {
  static const errorCode = "unknown-error";
  static const errorMessage = "Unexpected error occured";

  UnexpectedError(
      {String code = errorCode,
      String message = errorMessage,
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}
