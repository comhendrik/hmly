import 'package:household_organizer/core/error/failure.dart';
import '../entities/household_task.dart';
import 'package:dartz/dartz.dart';

abstract class HouseholdTaskRepository {
  Future<Either<Failure, List<HouseholdTask>>> getAllTasksForHousehold(String householdId);
  Future<Either<Failure, HouseholdTask>> createHouseholdTask(String householdId, String title, int pointsWorth, DateTime dueTo);
  Future<Either<Failure, void>> toggleIsDoneHouseholdTask(HouseholdTask task, String userId);
  Future<Either<Failure, void>> deleteHouseholdTask(String taskId);
  Future<Either<Failure, void>> updateHouseholdTask(HouseholdTask task, Map<String, dynamic> updateData);
}