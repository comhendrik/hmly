import 'package:dartz/dartz.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login({required this.repository});

  Future<Either<Failure, User>> execute(String email, String password) async {
    return await repository.login(email, password);
  }
}