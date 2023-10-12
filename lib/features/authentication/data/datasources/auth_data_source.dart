import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class AuthDataSource {
  Future<void> addAuthDataToHousehold(String userId, String householdId);
  Future<String> createHouseholdAndAddAuthData(String userId, String householdTitle);
  Future<void> deleteAuthDataFromHousehold(User user);
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String email, String password,String passwordConfirm, String username, String name);
  Future<UserModel> loadAuthDataWithOAuth();
  void logout();
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
  Future<void> addAuthDataToHousehold(String userId, String householdId) async {
    try {
      final _ =  await householdRecordService.getOne(householdId);
    } catch(err) {
      throw NotFoundException();
    }
    final body = <String, dynamic>{
      "household": householdId,
    };
    try {
      final _ = await userRecordService.update(userId, body: body);
    } catch(err) {
      print(err);
      throw ServerException();
    }
  }

  @override
  Future<String> createHouseholdAndAddAuthData(String userId, String householdTitle) async {
    final body = <String, dynamic>{
      "title": householdTitle,
    };
    try {
      final result = await householdRecordService.create(body: body);
      await addAuthDataToHousehold(userId, result.id);
      return result.id;
    } catch(err) {
      print(err);
      throw ServerException();
    }

  }

  @override
  Future<void> deleteAuthDataFromHousehold(User user) async {
    final body = <String, dynamic>{
      "household" : ""
    };
    try {
      final _ = await userRecordService.update(user.id, body: body);
    } catch(err) {
      print(err);
      throw ServerException();
    }
  }



  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final _ = await userRecordService.authWithPassword(email, password);
      RecordModel user = authStore.model;
      return UserModel.fromJSON(user.data, user.id);

    } catch (_) {
      throw ServerException();
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
      final dayList = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
      for (var i = 1; i < 8; i++) {
        final pointBody = <String, dynamic>{
          "day": dayList[i-1],
          "day_number": i,
          "value" : 0,
          "user" : record.id,
        };
        pointsRecordService.create(body: pointBody);
      }
      login(email, password);
      return UserModel.fromJSON(record.data, record.id);
    } catch(err) {
      print(err);
      throw ServerException();
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
        //TODO: When cancelling it shows a loading view

      });
      //TODO error on specific emails
      RecordModel user = authStore.model;
      return UserModel.fromJSON(user.data, user.id);

    } catch (err) {
      print(err);
      throw ServerException();
    }
  }

  @override
  void logout() async {
    print(authStore.model);
    authStore.clear();
    print(authStore.model);
  }
}