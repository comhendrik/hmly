import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:hmly/features/household_task/domain/entities/household_task.dart';
import 'package:hmly/features/household_task/domain/repositories/household_task_repository.dart';

class HouseholdTaskRepositoryImpl implements HouseholdTaskRepository {

  final HouseholdTaskRemoteDataSource remoteDataSource;

  HouseholdTaskRepositoryImpl({
    required this.remoteDataSource
  });

  @override
  Future<Either<Failure, List<HouseholdTask>>> getAllTasksForHousehold(String householdID) async {
    try {
      return Right(await remoteDataSource.getAllTaskForHousehold(householdID));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }


  @override
  Future<Either<Failure, HouseholdTask>> createHouseholdTask(String householdID, String title, int pointsWorth, DateTime dueTo) async {
    try {
      //to create a new record even the datetime has to be passed as a string.
      return Right(await remoteDataSource.createHouseholdTask(householdID, title, pointsWorth, dueTo.toString()));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> toggleIsDoneHouseholdTask(HouseholdTask task, String userID) async {
    try {
      return Right(await remoteDataSource.toggleIsDoneHouseholdTask(task, userID));
    } on KnownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.known));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHouseholdTask(String taskId) async {
    try {
      return Right(await remoteDataSource.deleteHouseholdTask(taskId));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> updateHouseholdTask(HouseholdTask task, Map<String, dynamic> updateData) async {
    try {
      return Right(await remoteDataSource.updateHouseholdTask(task, updateData));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }
}