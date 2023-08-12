import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/domain/repositories/household_task_repository.dart';

class CreateHouseholdTask {
  final HouseholdTaskRepository repository;

  CreateHouseholdTask({required this.repository});

  Future<Either<Failure, HouseholdTask>> execute(String householdId, String title, int pointsWorth) async {
    return await repository.createHouseholdTask(householdId, title, pointsWorth);
  }
}