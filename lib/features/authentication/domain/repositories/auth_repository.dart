import 'package:dartz/dartz.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/presentation/widgets/change_user_attributes_widget.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> addAuthDataToHousehold(String userID, String householdID);
  Future<Either<Failure, String>> createHouseholdAndAddAuthData(String userID);
  Future<Either<Failure, void>> leaveHousehold(UserData user);
  Future<Either<Failure, UserData>> login(String email, String password);
  Future<Either<Failure, UserData>> signUp(String email, String password, String passwordConfirm, String name);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserData>> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, UserData user, UserChangeType type);
  Future<Either<Failure, void>> requestNewPassword(String userEmail);
  Future<Either<Failure, void>> requestEmailChange(String newEmail, UserData user);
  Future<Either<Failure, void>> requestVerification(String email);
  Future<Either<Failure, UserData>> refreshAuthData();
  Future<Either<Failure, void>> deleteUser(UserData user, String password);
}