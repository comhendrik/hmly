import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login({required this.repository});

  Future<Either<Failure, User>> execute(String email, String password) async {
    return await repository.login(email, password);
  }
}