import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class LoadAuthDataWithOAuth {
  final AuthRepository repository;

  LoadAuthDataWithOAuth({required this.repository});

  Future<Either<Failure, User>> execute() async {
    return await repository.loadAuthDataWithOAuth();
  }
}