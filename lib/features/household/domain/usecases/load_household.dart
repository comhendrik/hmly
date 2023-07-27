import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';

class LoadHousehold {
  final HouseholdRepository repository;

  LoadHousehold({required this.repository});

  Future<Either<Failure, Household>> execute() async {
    return await repository.loadHousehold();
  }
}