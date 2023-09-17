import 'package:household_organizer/core/error/failure.dart';
import '../entities/household_task.dart';
import 'package:dartz/dartz.dart';

abstract class HouseholdTaskRepository {
  Future<Either<Failure, List<HouseholdTask>>> getAllTasksForHousehold(String householdId);
  Future<Either<Failure, HouseholdTask>> createHouseholdTask(String householdId, String title, int pointsWorth);
  Future<Either<Failure, void>> updateHouseholdTask(String taskId, bool isDone);
  Future<Either<Failure, void>> deleteHouseholdTask(String taskId);
}