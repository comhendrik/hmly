import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/data/datasources/household_remote_data_source.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';

class HouseholdRepositoryImpl implements HouseholdRepository {

  final HouseholdRemoteDataSource remoteDataSource;

  HouseholdRepositoryImpl({
    required this.remoteDataSource
  });

  @override
  Future<Either<Failure, Household>> loadHousehold(String householdID) async {
    try {
      return Right(await remoteDataSource.loadHousehold(householdID));
    } on ServerException {
      return const Left(Failure(msg: "ServerFailure", type: FailureType.server));
    }
  }

  @override
  Future<Either<Failure, Household>> updateHouseholdTitle(String householdID, String householdTitle) async {
    try {
      return Right(await remoteDataSource.updateHouseholdTitle(householdID, householdTitle));
    } on ServerException {
      return const Left(Failure(msg: "ServerFailure", type: FailureType.server));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAuthDataFromHousehold(String userID) async {
    try {
      return Right(await remoteDataSource.deleteAuthDataFromHousehold(userID));
    } on ServerException {
      return const Left(Failure(msg: "ServerFailure", type: FailureType.server));
    }
  }

  @override
  Future<Either<Failure, Household>> updateAdmin(String householdID, String userID) async {
    try {
      return Right(await remoteDataSource.updateAdmin(householdID, userID));
    } on ServerException {
      return const Left(Failure(msg: "ServerFailure", type: FailureType.server));
    }
  }


}