import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/domain/repositories/household_task_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateHouseholdTask {
  final HouseholdTaskRepository repository;

  UpdateHouseholdTask({
    required this.repository
  });

  Future<Either<Failure, void>> execute(String taskId, bool isDone) async {
    return await repository.updateHouseholdTask(taskId, isDone);
  }
}