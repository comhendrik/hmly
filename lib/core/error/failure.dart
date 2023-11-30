import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  unknown,
  known
}

extension FailureTypeExtension on FailureType {
  String title(BuildContext context) {
    switch (this) {
      case FailureType.server:
        return AppLocalizations.of(context)!.serverFailure;
      case FailureType.cache:
        return AppLocalizations.of(context)!.cacheFailure;
      case FailureType.notFound:
        return AppLocalizations.of(context)!.notFoundFailure;
      case FailureType.unknown:
        return AppLocalizations.of(context)!.unknownFailure;
      case FailureType.known:
        return AppLocalizations.of(context)!.knownFailure;
    }
  }
}
