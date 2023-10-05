import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';

class UpdateHouseholdTitle {
  final HouseholdRepository repository;

  UpdateHouseholdTitle({required this.repository});

  Future<Either<Failure, Household>> execute(String householdId, String householdTitle) async {
    return await repository.updateHouseholdTitle(householdId, householdTitle);
  }
}