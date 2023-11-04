import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/change_user_attributes_widget.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

abstract class AuthDataSource {
  Future<void> addAuthDataToHousehold(String userID, String householdID);
  Future<String> createHouseholdAndAddAuthData(String userID, String householdTitle);
  Future<void> leaveHousehold(User user);
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String email, String password,String passwordConfirm, String username, String name);
  Future<UserModel> loadAuthDataWithOAuth();
  Future<void> logout();
  Future<UserModel> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, User user, UserChangeType type);
  Future<void> requestNewPassword(String userEmail);
  Future<void> requestEmailChange(String newEmail, User user);
  Future<void> requestVerification(String email);
  Future<void> refreshAuthData();
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
      final _ = await userRecordService.update(userID, body: body);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<String> createHouseholdAndAddAuthData(String userID, String householdTitle) async {
    final body = <String, dynamic>{
      "title": householdTitle,
      "admin": userID,
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
      createWeeklyPoints(record.id);
      login(email, password);
      return UserModel.fromJSON(record.data, record.id);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserModel> loadAuthDataWithOAuth() async {
    try {
      final authData = await userRecordService.authWithOAuth2(
          'google',
          createData:  {
            "name" : "google",
          },
          (url) async {
        // or use something like flutter_custom_tabs to make the transitions between native and web content more seamless
        await launchUrl(url);
        //TODO: When cancelling it shows a loading view /Later Release

      });
      RecordModel user = authStore.model;

      //TODO: Point creation is needed but only when signing user in with oauth /Later Release
      //createWeeklyPoints(user.id);
      return UserModel.fromJSON(user.data, user.id);

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
    await userRecordService.requestPasswordReset(userEmail);
  }

  @override
  Future<void> requestEmailChange(String newEmail, User user) async {
    await userRecordService.requestEmailChange(newEmail);
  }

  @override
  Future<void> requestVerification(String email) async {
    await userRecordService.requestVerification(email);
  }

  @override
  Future<void> refreshAuthData() async {
    await userRecordService.authRefresh();
  }


  void createWeeklyPoints(String userID) async {
    final dayList = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    for (var i = 1; i < 8; i++) {
      final pointBody = <String, dynamic>{
        "day": dayList[i-1],
        "day_number": i,
        "value" : 0,
        "user" : userID,
      };
      pointsRecordService.create(body: pointBody);
    }
  }
}