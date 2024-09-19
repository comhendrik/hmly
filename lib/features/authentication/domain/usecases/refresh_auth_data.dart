import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/entities/user.dart';

class RefreshAuthData {
  final AuthRepository repository;

  RefreshAuthData({required this.repository});

  Future<Either<Failure, UserData>> execute() async {
    return await repository.refreshAuthData();
  }
}