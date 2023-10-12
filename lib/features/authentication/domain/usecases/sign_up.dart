import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp({required this.repository});

  Future<Either<Failure, User>> execute(String email, String password, String passwordConfirm, String username, String name) async {
    return await repository.signUp(email, password, passwordConfirm, username, name);
  }
}