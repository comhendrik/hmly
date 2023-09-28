import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class AuthDataSource {
  Future<void> addAuthDataToHousehold(String userId, String householdId);
  Future<void> deleteAuthDataFromHousehold(User user);
  Future<void> createAuthData(String email, String password);
  Future<UserModel> loadAuthData();
  Future<UserModel> createAuthDataOnServer(String email, String password,String passwordConfirm, String username, String name);
}

class AuthDataSourceImpl implements AuthDataSource {

  final RecordService userRecordService;
  final RecordService householdRecordService;
  final FlutterSecureStorage storage;

  AuthDataSourceImpl({required this.userRecordService, required this.householdRecordService, required this.storage});

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
  Future<void> createAuthData(String email, String password) async {
    await storage.write(key: "email", value: email);
    await storage.write(key: "password", value: password);
  }

  @override
  Future<UserModel> loadAuthData() async {
    String email = await storage.read(key: "email") ?? "no data";
    String password = await storage.read(key: "password") ?? "no data";
    if (email == "no data" || password == "no data") {
      throw CacheException();
    }
    try {
      final _ = await userRecordService.authWithPassword(email, password);
      final user = await userRecordService.getFirstListItem('email="$email"');
      return UserModel.fromJSON(user.data, user.id);

    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> createAuthDataOnServer(String email, String password, String passwordConfirm, String username, String name) async {
    final body = <String, dynamic>{
      "username": username,
      "email": email,
      "emailVisibility": true,
      "password": password,
      "passwordConfirm": passwordConfirm,
      "name": name,
      "weeklyPoints": 0,
    };
    try {
      final record = await userRecordService.create(body: body);
      return UserModel.fromJSON(record.data, record.id);
    } catch(err) {
      print(err);
      throw ServerException();
    }
  }
}