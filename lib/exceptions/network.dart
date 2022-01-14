class NetworkError implements Exception {
  final String msg;

  NetworkError({required this.msg});

  @override
  String toString() {
    return msg;
  }
}
