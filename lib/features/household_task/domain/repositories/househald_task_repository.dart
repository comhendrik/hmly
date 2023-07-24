import 'package:household_organizer/core/error/failure.dart';
import '../entities/household_task.dart';
import 'package:dartz/dartz.dart';

abstract class HouseholdTaskRepository {
  Future<Either<Failure, List<HouseholdTask>>> getAllTasksForHousehold();
}