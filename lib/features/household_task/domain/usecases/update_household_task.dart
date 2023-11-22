import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household_task/domain/entities/household_task.dart';
import 'package:hmly/features/household_task/domain/repositories/household_task_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateHouseholdTask {
  final HouseholdTaskRepository repository;

  UpdateHouseholdTask({
    required this.repository
  });

  Future<Either<Failure, void>> execute(HouseholdTask task, Map<String, dynamic> updateData) async {
    return await repository.updateHouseholdTask(task, updateData);
  }
}