import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final Map<String, dynamic> data;
  final FailureType type;

  const Failure({
    required this.data,
    required this.type,
  });

  @override
  List<Object> get props => [data, type];
}

enum FailureType {
  server,
  cache,
  notFound,
  unknown
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
      case FailureType.unknown:
        return "Unknown Failure";
    }
  }
}
