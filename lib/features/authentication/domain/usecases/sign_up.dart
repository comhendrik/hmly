import 'package:dartz/dartz.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp({required this.repository});

  Future<Either<Failure, User>> execute(String email, String password, String passwordConfirm, String username, String name) async {
    return await repository.signUp(email, password, passwordConfirm, username, name);
  }
}