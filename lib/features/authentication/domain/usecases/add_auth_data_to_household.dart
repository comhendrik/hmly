import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';

class AddAuthDataToHousehold {
  final AuthRepository repository;

  AddAuthDataToHousehold({required this.repository});

  Future<Either<Failure, void>> execute(String userID, String householdID) async {
    return await repository.addAuthDataToHousehold(userID,householdID);
  }
}