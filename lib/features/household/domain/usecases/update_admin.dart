import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';

class UpdateAdmin {
  final HouseholdRepository repository;

  UpdateAdmin({required this.repository});

  Future<Either<Failure, Household>> execute(String householdID, String userID) async {
    return await repository.updateAdmin(householdID, userID);
  }
}