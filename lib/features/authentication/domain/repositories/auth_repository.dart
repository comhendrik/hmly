import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> addAuthDataToHousehold(String userID, String householdID);
  Future<Either<Failure, String>> createHouseholdAndAddAuthData(String userID, String householdTitle);
  Future<Either<Failure, void>> leaveHousehold(User user);
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> signUp(String email, String password, String passwordConfirm, String username, String name);
  Future<Either<Failure, User>> loadAuthDataWithOAuth();
  void logout();
}