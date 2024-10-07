import 'package:dartz/dartz.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';

class RequestEmailChange {
  final AuthRepository repository;

  RequestEmailChange({required this.repository});

  Future<Either<Failure, void>> execute(String newEmail, String password, UserData user) async {
    return await repository.requestEmailChange(newEmail, password, user);
  }
}