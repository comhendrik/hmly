

import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/entities/Auth.dart';

abstract class AuthRepository {
  Future<void> createAuthData(String email, String password);
  Future<Either<Failure, Auth>> loadAuthData();
}