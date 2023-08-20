import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/data/datasources/auth_data_source.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthDataSource localDataSource;

  AuthRepositoryImpl({
    required this.localDataSource
  });

  @override
  Future<void> createAuthData(String email, String password) async {
    await localDataSource.createAuthData(email, password);
  }


  @override
  Future<Either<Failure, User>> loadAuthData() async {
    try {
      return Right(await localDataSource.loadAuthData());
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> createAuthDataOnServer(String email, String password, String passwordConfirm, String username, String name) async {
    try {
      return Right(await localDataSource.createAuthDataOnServer(email, password, passwordConfirm, username, name));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}