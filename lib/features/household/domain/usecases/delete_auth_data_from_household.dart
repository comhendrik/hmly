import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';

class DeleteAuthDataFromHousehold {
  final HouseholdRepository repository;

  DeleteAuthDataFromHousehold({required this.repository});

  Future<Either<Failure, void>> execute(String userID) async {
    return await repository.deleteAuthDataFromHousehold(userID);
  }
}