import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class AuthLocalDataSource {
  Future<void> createAuthData(String email, String password);
  Future<UserModel> loadAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {

  final RecordService userRecordService;
  final RecordService householdRecordService;
  final FlutterSecureStorage storage;

  AuthLocalDataSourceImpl({required this.userRecordService, required this.householdRecordService, required this.storage});

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
}