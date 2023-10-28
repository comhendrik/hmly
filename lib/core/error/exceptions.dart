class ServerException implements Exception {

  ///Exception when there is a failure in context with the server.
  final Map<String,dynamic> response;

  const ServerException({
    required this.response,
  });
}
class NotFoundException implements Exception {
  final Map<String,dynamic> response;

  const NotFoundException({
    required this.response,
  });
}

class UnknownException implements Exception {

  final Map<String, dynamic> response = {
    "message" : "The Failure is based on some unknown error. Please explain your failure in detail and send it to our support."
  };
}