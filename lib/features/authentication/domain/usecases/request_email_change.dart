import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class RequestEmailChange {
  final AuthRepository repository;

  RequestEmailChange({required this.repository});

  Future<Either<Failure, void>> execute(String newEmail, User user) async {
    return await repository.requestEmailChange(newEmail, user);
  }
}