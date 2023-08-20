import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class CreateAuthDataOnServer {
  final AuthRepository repository;

  CreateAuthDataOnServer({required this.repository});

  Future<Either<Failure, User>> execute(String email, String password, String passwordConfirm, String username, String name) async {
    return await repository.createAuthDataOnServer(email, password, passwordConfirm, username, name);
  }
}