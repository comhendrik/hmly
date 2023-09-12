import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/domain/repositories/household_task_repository.dart';

class HouseholdTaskRepositoryImpl implements HouseholdTaskRepository {

  final HouseholdTaskRemoteDataSource remoteDataSource;

  HouseholdTaskRepositoryImpl({
    required this.remoteDataSource
  });

  @override
  Future<Either<Failure, List<HouseholdTask>>> getAllTasksForHousehold(String householdId) async {
    try {
      return Right(await remoteDataSource.getAllTaskForHousehold(householdId));
    } on ServerException {
      return Left(ServerFailure());
    }
  }


  @override
  Future<Either<Failure, HouseholdTask>> createHouseholdTask(String householdId, String title, int pointsWorth) async {
    try {
      return Right(await remoteDataSource.createHouseholdTask(householdId, title, pointsWorth));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateHouseholdTask(String taskId, bool isDone) async {
    try {
      return Right(await remoteDataSource.updateHouseholdTask(taskId, isDone));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}