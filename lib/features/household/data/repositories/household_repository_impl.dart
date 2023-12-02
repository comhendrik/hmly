import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household/data/datasources/household_data_source.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:hmly/features/household/domain/repositories/household_repository.dart';

class HouseholdRepositoryImpl implements HouseholdRepository {

  final HouseholdDataSource remoteDataSource;

  HouseholdRepositoryImpl({
    required this.remoteDataSource
  });

  @override
  Future<Either<Failure, Household>> loadHousehold(String householdID) async {
    try {
      return Right(await remoteDataSource.loadHousehold(householdID));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, Household>> updateHouseholdTitle(Household household, String householdTitle) async {
    try {
      return Right(await remoteDataSource.updateHouseholdTitle(household, householdTitle));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAuthDataFromHousehold(String userID) async {
    try {
      return Right(await remoteDataSource.deleteAuthDataFromHousehold(userID));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, Household>> updateAdmin(String householdID, String userID) async {
    try {
      return Right(await remoteDataSource.updateAdmin(householdID, userID));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHousehold(String householdID) async {
    try {
      return Right(await remoteDataSource.deleteHousehold(householdID));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, Household>> updateAllowedUsers(String userID, Household household, bool delete) async {
    try {
      return Right(await remoteDataSource.updateAllowedUsers(userID, household, delete));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

}