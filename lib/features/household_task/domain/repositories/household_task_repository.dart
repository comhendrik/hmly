import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/failure.dart';
import '../entities/household_task.dart';
import 'package:dartz/dartz.dart';

abstract class HouseholdTaskRepository {
  Future<Either<Failure, List<HouseholdTask>>> getAllTasksForHousehold(String householdID);
  Future<Either<Failure, HouseholdTask>> createHouseholdTask(String householdID, String title, int pointsWorth, DateTime dueTo);
  Future<Either<Failure, void>> toggleIsDoneHouseholdTask(HouseholdTask task, UserData user);
  Future<Either<Failure, void>> deleteHouseholdTask(String householdID, String taskId);
  Future<Either<Failure, void>> updateHouseholdTask(String householdID, HouseholdTask task, Map<String, dynamic> updateData);
}