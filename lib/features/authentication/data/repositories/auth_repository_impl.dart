import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/data/datasources/auth_data_source.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/change_user_attributes_widget.dart';

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
    }
  }

  @override
  Future<Either<Failure, String>> createHouseholdAndAddAuthData(String userID, String householdTitle) async {
    try {
      return Right(await dataSource.createHouseholdAndAddAuthData(userID, householdTitle));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on NotFoundException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.notFound));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }



  @override
  Future<Either<Failure, void>> leaveHousehold(User user) async {
    try {
      return Right(await dataSource.leaveHousehold(user));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }




  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      return Right(await dataSource.login(email, password));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String email, String password, String passwordConfirm, String username, String name) async {
    try {
      return Right(await dataSource.signUp(email, password, passwordConfirm, username, name));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, User>> loadAuthDataWithOAuth() async {
    try {
      return Right(await dataSource.loadAuthDataWithOAuth());
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }



  @override
  void logout() async {
    dataSource.logout();
  }


  @override
  Future<Either<Failure, User>> changeUserAttributes(String input, String? token, String? confirmationPassword, String? oldPassword, String userID, UserChangeType type) async {
    try {
      return Right(await dataSource.changeUserAttributes(input, token, confirmationPassword, oldPassword, userID, type));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<void> requestNewPassword(String userEmail) async {
    await dataSource.requestNewPassword(userEmail);
  }
}