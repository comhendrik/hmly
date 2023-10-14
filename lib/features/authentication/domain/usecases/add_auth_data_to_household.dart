import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class AddAuthDataToHousehold {
  final AuthRepository repository;

  AddAuthDataToHousehold({required this.repository});

  Future<Either<Failure, void>> execute(String userID, String householdID) async {
    return await repository.addAuthDataToHousehold(userID,householdID);
  }
}