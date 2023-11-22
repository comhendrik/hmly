import 'package:dartz/dartz.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';

class LoadAuthDataWithOAuth {
  final AuthRepository repository;

  LoadAuthDataWithOAuth({required this.repository});

  Future<Either<Failure, User>> execute() async {
    return await repository.loadAuthDataWithOAuth();
  }
}