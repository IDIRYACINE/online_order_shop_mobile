abstract class CustomException implements Exception {
  CustomException({this.code = "unkown", this.message, this.stackTrace});

  final String code;
  final String? message;
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CustomException) return false;
    return other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(code, message);

  @override
  String toString() {
    String output = '[$code] $message';
    if (stackTrace != null) {
      output += '\n\n${stackTrace.toString()}';
    }

    return output;
  }
}
