import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household_task/domain/repositories/household_task_repository.dart';

class DeleteHouseholdTask {
  final HouseholdTaskRepository repository;

  DeleteHouseholdTask({required this.repository});

  Future<Either<Failure, void>> execute(String taskId) async {
    return await repository.deleteHouseholdTask(taskId);
  }
}