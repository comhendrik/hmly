import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household_task/domain/entities/household_task.dart';
import 'package:hmly/features/household_task/domain/repositories/household_task_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllTasksForHousehold {
  final HouseholdTaskRepository repository;

  GetAllTasksForHousehold(this.repository);

  Future<Either<Failure, List<HouseholdTask>>> execute(String householdID) async {
    return await repository.getAllTasksForHousehold(householdID);
  }
}