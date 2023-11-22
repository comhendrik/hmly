import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:hmly/features/household/domain/repositories/household_repository.dart';

class LoadHousehold {
  final HouseholdRepository repository;

  LoadHousehold({required this.repository});

  Future<Either<Failure, Household>> execute(String householdID) async {
    return await repository.loadHousehold(householdID);
  }
}