import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household_task/domain/entities/household_task.dart';
import 'package:hmly/features/household_task/domain/repositories/household_task_repository.dart';

class CreateHouseholdTask {
  final HouseholdTaskRepository repository;

  CreateHouseholdTask({required this.repository});

  Future<Either<Failure, HouseholdTask>> execute(String householdID, String title, int pointsWorth, DateTime dueTo) async {
    return await repository.createHouseholdTask(householdID, title, pointsWorth, dueTo);
  }
}