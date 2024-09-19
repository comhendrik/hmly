import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/models/user_model.dart';
import 'package:hmly/features/authentication/presentation/widgets/change_user_attributes_widget.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
  Future<void> addAuthDataToHousehold(String userID, String householdID);
  Future<String> createHouseholdAndAddAuthData(String userID, String householdTitle);
  Future<void> leaveHousehold(UserData user);
  Future<UserDataModel> login(String email, String password);
  Future<UserDataModel> signUp(String email, String password,String passwordConfirm, String username, String name);
  Future<void> logout();
  Future<UserDataModel> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, UserData user, UserChangeType type);
  Future<void> requestNewPassword(String userEmail);
  Future<void> requestEmailChange(String newEmail, UserData user);
  Future<void> requestVerification(String email);
  Future<UserDataModel> refreshAuthData();
  Future<void> deleteUser(UserData user);
}

class AuthDataSourceImpl implements AuthDataSource {

  final RecordService userRecordService;
  final RecordService householdRecordService;
  final RecordService pointsRecordService;
  final AuthStore authStore;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
  Future<void> leaveHousehold(UserData user) async {
    try {
      final body = <String, dynamic> {
        "household" : ""
      };
      final _ = await userRecordService.update("//TODO: should be changed", body: body);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> login(String email, String password) async {
    try {
      final t = await userRecordService.authWithPassword(email, password);

      final _ = await auth.signInWithEmailAndPassword(email: email, password: password);
      final userData = await loadUserData();
      return userData;
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (err) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> signUp(String email, String password, String passwordConfirm, String username, String name) async {
    final body = <String, dynamic>{
      "username": username,
      "email": email,
      "emailVisibility": true,
      "password": password,
      "passwordConfirm": passwordConfirm,
      "name": name,
    };
    try {

      final _ = await auth.createUserWithEmailAndPassword(email: email, password: password);


      final __ = await userRecordService.create(body: body);
      login(email, password);

      return await loadUserData();
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await auth.signOut();
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, UserData user, UserChangeType type) async {
    try {
      Map<String, dynamic> data = {};
      switch (type) {
        case UserChangeType.email:

          throw Exception("Type email shouldn't be used in this context!!");

        case UserChangeType.name || UserChangeType.username:

          data.addAll({type.stringKey : input});
          final result = await userRecordService.update("//TODO: should be changed", body: data);
          return await loadUserData();

        case UserChangeType.password:

          if (confirmationPassword == null || oldPassword == null) throw Exception("No confirmation or old password");
          data.addAll({
            type.stringKey : input,
            "oldPassword" : oldPassword,
            "passwordConfirm" : confirmationPassword,
          });
          final result = await userRecordService.update("//TODO: should be changed", body: data);
          return await loadUserData();
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
  Future<void> requestEmailChange(String newEmail, UserData user) async {
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
  Future<UserDataModel> refreshAuthData() async {
    try {
      await auth.currentUser?.reload();
      return await loadUserData();
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteUser(UserData user) async {
    try {
      final points = await pointsRecordService.getFullList(filter: 'user="${"//TODO: should be changed"}"');
      for (RecordModel point in points) {
        pointsRecordService.delete(point.id);
      }
      userRecordService.delete("//TODO: should be changed");

    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  Future<UserDataModel> loadUserData() async {
    if (auth.currentUser == null) throw UnknownException(); //TODO: implement new exception type
    try {
      final userData = await firestore.collection("users").doc(auth.currentUser!.uid).get();
      if (userData.data() == null) throw UnknownException(); //TODO: implement new exception type
      return UserDataModel.fromJSON(userData.data()!, auth.currentUser!.uid, auth.currentUser!.email!);
    } on FirebaseException catch(e) {
      print(e.toString());
      throw UnknownException(); //TODO: Implement new exception type
    }
  }
}