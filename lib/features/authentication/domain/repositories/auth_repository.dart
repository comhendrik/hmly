import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';

abstract class AuthRepository {
  Future<void> createAuthData(String email, String password);
  Future<Either<Failure, User>> loadAuthData();
  Future<Either<Failure, User>> createAuthDataOnServer(String email, String password, String passwordConfirm, String username, String name);
}