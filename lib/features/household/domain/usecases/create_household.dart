import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';

class CreateHousehold {
  final HouseholdRepository repository;

  CreateHousehold({required this.repository});

  Future<Either<Failure, void>> execute(String title, int minWeeklyPoints) async {
    return await repository.createHousehold(title, minWeeklyPoints);
  }
}