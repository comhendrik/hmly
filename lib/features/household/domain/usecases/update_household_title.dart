import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:hmly/features/household/domain/repositories/household_repository.dart';

class UpdateHouseholdTitle {
  final HouseholdRepository repository;

  UpdateHouseholdTitle({required this.repository});

  Future<Either<Failure, Household>> execute(String householdID, String householdTitle) async {
    return await repository.updateHouseholdTitle(householdID, householdTitle);
  }
}