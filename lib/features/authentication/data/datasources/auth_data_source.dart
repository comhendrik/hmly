import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/models/user_model.dart';
import 'package:hmly/features/authentication/presentation/widgets/change_user_attributes_widget.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';

abstract class AuthDataSource {
  Future<void> addAuthDataToHousehold(String userID, String householdID);
  Future<String> createHouseholdAndAddAuthData(String userID, String householdTitle);
  Future<void> leaveHousehold(User user);
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String email, String password,String passwordConfirm, String username, String name);
  Future<void> logout();
  Future<UserModel> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, User user, UserChangeType type);
  Future<void> requestNewPassword(String userEmail);
  Future<void> requestEmailChange(String newEmail, User user);
  Future<void> requestVerification(String email);
  Future<void> refreshAuthData();
  Future<void> deleteUser(User user);
}

class AuthDataSourceImpl implements AuthDataSource {

  final RecordService userRecordService;
  final RecordService householdRecordService;
  final RecordService pointsRecordService;
  final AuthStore authStore;

  AuthDataSourceImpl({
    required this.userRecordService,
    required this.householdRecordService,
    required this.pointsRecordService,
    required this.authStore,
  });

  @override
  Future<void> addAuthDataToHousehold(String userID, String householdID) async {
    final body = <String, dynamic>{
      "household": householdID,
    };
    try {
      final household = await householdRecordService.getOne(householdID);
      bool isAllowed = false;
      for (String id in household.data["allowed_users"]) {
        if (id == userID) {
          isAllowed = true;
        }
      }
      if (!isAllowed) {
        throw KnownException("You are ID is not allowed in this institution, please contact the admin.");
      }
      final _ = await userRecordService.update(userID, body: body);
    } on ClientException catch (err) {
      throw ServerException(response: err.response);
    } on KnownException catch (err){
      throw KnownException(err.response["message"]);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<String> createHouseholdAndAddAuthData(String userID, String householdTitle) async {
    final body = <String, dynamic>{
      "title": householdTitle,
      "admin": userID,
      "allowed_users" : [userID]
    };
    try {
      final result = await householdRecordService.create(body: body);
      await addAuthDataToHousehold(userID, result.id);
      return result.id;
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<void> leaveHousehold(User user) async {
    try {
      final body = <String, dynamic> {
        "household" : ""
      };
      final _ = await userRecordService.update(user.id, body: body);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final _ = await userRecordService.authWithPassword(email, password);
      RecordModel user = authStore.model;
      return UserModel.fromJSON(user.data, user.id);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (err) {
      throw UnknownException();
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String passwordConfirm, String username, String name) async {
    final body = <String, dynamic>{
      "username": username,
      "email": email,
      "emailVisibility": true,
      "password": password,
      "passwordConfirm": passwordConfirm,
      "name": name,
    };
    try {
      final record = await userRecordService.create(body: body);
      login(email, password);
      return UserModel.fromJSON(record.data, record.id);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      authStore.clear();
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserModel> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, User user, UserChangeType type) async {
    try {
      Map<String, dynamic> data = {};
      switch (type) {
        case UserChangeType.email:

          throw Exception("Type email shouldn't be used in this context!!");

        case UserChangeType.name || UserChangeType.username:

          data.addAll({type.stringKey : input});
          final result = await userRecordService.update(user.id, body: data);
          return UserModel.fromJSON(result.data, result.id);

        case UserChangeType.password:

          if (confirmationPassword == null || oldPassword == null) throw Exception("No confirmation or old password");
          data.addAll({
            type.stringKey : input,
            "oldPassword" : oldPassword,
            "passwordConfirm" : confirmationPassword,
          });
          final result = await userRecordService.update(user.id, body: data);
          return UserModel.fromJSON(result.data, result.id);
      }
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> requestNewPassword(String userEmail) async {

    try {
      await userRecordService.requestPasswordReset(userEmail);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> requestEmailChange(String newEmail, User user) async {
    try {
      await userRecordService.requestEmailChange(newEmail);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<void> requestVerification(String email) async {
    try {
      await userRecordService.requestVerification(email);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> refreshAuthData() async {
    try {
      await userRecordService.authRefresh();
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteUser(User user) async {
    try {
      final points = await pointsRecordService.getFullList(filter: 'user="${user.id}"');
      for (RecordModel point in points) {
        pointsRecordService.delete(point.id);
      }
      userRecordService.delete(user.id);

    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }
}