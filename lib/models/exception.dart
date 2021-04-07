class ExceptionHandle implements Exception {
  final String message;

  ExceptionHandle(this.message);

  @override
  String toString() {
    return message;
  }
}
