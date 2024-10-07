import 'package:dartz/dartz.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/data/datasources/auth_data_source.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';
import 'package:hmly/features/authentication/presentation/widgets/change_user_attributes_widget.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthDataSource dataSource;

  AuthRepositoryImpl({
    required this.dataSource
  });

  @override
  Future<Either<Failure, void>> addAuthDataToHousehold(String userID, String householdID) async {
    try {
      return Right(await dataSource.addAuthDataToHousehold(userID, householdID));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    } on KnownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.known));
    }
  }

  @override
  Future<Either<Failure, String>> createHouseholdAndAddAuthData(String userID) async {
    try {
      return Right(await dataSource.createHouseholdAndAddAuthData(userID));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on NotFoundException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.notFound));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }



  @override
  Future<Either<Failure, void>> leaveHousehold(UserData user) async {
    try {
      return Right(await dataSource.leaveHousehold(user));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }




  @override
  Future<Either<Failure, UserData>> login(String email, String password) async {
    try {
      return Right(await dataSource.login(email, password));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, UserData>> signUp(String email, String password, String passwordConfirm, String name) async {
    try {
      return Right(await dataSource.signUp(email, password, passwordConfirm, name));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }


  @override
  Future<Either<Failure, void>> logout() async {
    try {
      return Right(await dataSource.logout());
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }


  @override
  Future<Either<Failure, UserData>> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, UserData user, UserChangeType type) async {
    try {
      return Right(await dataSource.changeUserAttributes(input, confirmationPassword, oldPassword, user, type));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> requestNewPassword(String userEmail) async {
    try {
      return Right(await dataSource.requestNewPassword(userEmail));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> requestEmailChange(String newEmail, String password, UserData user) async {
    try {
      return Right(await dataSource.requestEmailChange(newEmail, password, user));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> requestVerification() async {
    try {
      return Right(await dataSource.requestVerification());
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, UserData>> refreshAuthData() async {
    try {
      return Right(await dataSource.refreshAuthData());
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(UserData user, String password) async {
    try {
      return Right(await dataSource.deleteUser(user, password));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

}