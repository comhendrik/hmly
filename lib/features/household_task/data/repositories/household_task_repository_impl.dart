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
  Future<Either<Failure, List<HouseholdTask>>> getAllTasksForHousehold(String householdID) async {
    try {
      return Right(await remoteDataSource.getAllTaskForHousehold(householdID));
    } on ServerException {
      return const Left(Failure(msg: "ServerFailure", type: FailureType.server));
    }
  }


  @override
  Future<Either<Failure, HouseholdTask>> createHouseholdTask(String householdID, String title, int pointsWorth, DateTime dueTo) async {
    try {
      //to create a new record even the datetime has to be passed as a string.
      return Right(await remoteDataSource.createHouseholdTask(householdID, title, pointsWorth, dueTo.toString()));
    } on ServerException {
      return const Left(Failure(msg: "ServerFailure", type: FailureType.server));
    }
  }

  @override
  Future<Either<Failure, void>> toggleIsDoneHouseholdTask(HouseholdTask task, String userID) async {
    try {
      return Right(await remoteDataSource.toggleIsDoneHouseholdTask(task, userID));
    } on ServerException {
      return const Left(Failure(msg: "ServerFailure", type: FailureType.server));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHouseholdTask(String taskId) async {
    try {
      return Right(await remoteDataSource.deleteHouseholdTask(taskId));
    } on ServerException {
      return const Left(Failure(msg: "ServerFailure", type: FailureType.server));
    }
  }

  @override
  Future<Either<Failure, void>> updateHouseholdTask(HouseholdTask task, Map<String, dynamic> updateData) async {
    try {
      return Right(await remoteDataSource.updateHouseholdTask(task, updateData));
    } on ServerException {
      return const Left(Failure(msg: "ServerFailure", type: FailureType.server));
    }
  }
}