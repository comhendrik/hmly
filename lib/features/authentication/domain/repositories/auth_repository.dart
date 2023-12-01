import 'package:dartz/dartz.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/presentation/widgets/change_user_attributes_widget.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> addAuthDataToHousehold(String userID, String householdID);
  Future<Either<Failure, String>> createHouseholdAndAddAuthData(String userID, String householdTitle);
  Future<Either<Failure, void>> leaveHousehold(User user);
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> signUp(String email, String password, String passwordConfirm, String username, String name);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, User user, UserChangeType type);
  Future<Either<Failure, void>> requestNewPassword(String userEmail);
  Future<Either<Failure, void>> requestEmailChange(String newEmail, User user);
  Future<Either<Failure, void>> requestVerification(String email);
  Future<Either<Failure, void>> refreshAuthData();
  Future<Either<Failure, void>> deleteUser(User user);
}