import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String msg;
  final FailureType type;

  const Failure({
    required this.msg,
    required this.type,
  });

  @override
  List<Object> get props => [msg];
}

enum FailureType {
  server,
  cache,
  notFound
}

extension FailureTypeExtension on FailureType {
  String get title {
    switch (this) {
      case FailureType.server:
        return "Server Failure";
      case FailureType.cache:
        return "Cache Failure";
      case FailureType.notFound:
        return "Not Found Failure";
    }
  }
}
