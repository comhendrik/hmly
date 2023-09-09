import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/data/datasources/auth_data_source.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthDataSource dataSource;

  AuthRepositoryImpl({
    required this.dataSource
  });

  @override
  Future<Either<Failure, void>> addAuthDataToHousehold(String userId, String householdId) async {
    try {
      return Right(await dataSource.addAuthDataToHousehold(userId, householdId));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAuthDataFromHousehold(User user) async {
    try {
      return Right(await dataSource.deleteAuthDataFromHousehold(user));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> createAuthData(String email, String password) async {
    await dataSource.createAuthData(email, password);
  }


  @override
  Future<Either<Failure, User>> loadAuthData() async {
    try {
      return Right(await dataSource.loadAuthData());
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> createAuthDataOnServer(String email, String password, String passwordConfirm, String username, String name) async {
    try {
      return Right(await dataSource.createAuthDataOnServer(email, password, passwordConfirm, username, name));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}