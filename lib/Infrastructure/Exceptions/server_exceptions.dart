import 'custom_exception.dart';

class NetworkError extends CustomException {
  static const errorCode = "network-error";

  NetworkError(
      {String code = errorCode,
      String message = "A netowrk error occured",
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class OrderNotSent extends CustomException {
  static const errorCode = "order-not-sent";

  OrderNotSent(
      {String code = errorCode,
      String message = "Order couldn't be placed , try again later!",
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class OrderNotFound extends CustomException {
  static const errorCode = "Order-not-found";

  OrderNotFound(
      {String code = errorCode,
      String message = "Order couldn't be found ",
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class LocalDatabaseNotFound extends CustomException {
  static const errorCode = "local-db-not-found";

  LocalDatabaseNotFound(
      {String code = errorCode,
      String message = "Database couldn't be found ",
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class RemoteDatabaseNotFound extends CustomException {
  static const errorCode = "remote-db-not-found";

  RemoteDatabaseNotFound(
      {String code = errorCode,
      String message = "Database couldn't be found ",
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}

class InternalServerError extends CustomException {
  static const errorCode = "internal-server-error";

  InternalServerError(
      {String code = errorCode,
      String message = "Internal server error ",
      StackTrace? stackTrace})
      : super(code: code, message: message, stackTrace: stackTrace);
}
