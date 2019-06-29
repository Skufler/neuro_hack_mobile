class FetchDataException implements Exception {
  final _message;

  FetchDataException({String message}) : _message = message;

  String toString() {
    if (_message == null) return "FetchDataException";
    return "FetchDataException $_message";
  }
}
