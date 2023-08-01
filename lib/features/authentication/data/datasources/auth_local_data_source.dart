import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/authentication/data/models/auth_model.dart';

abstract class AuthLocalDataSource {
  Future<void> createAuthData(String email, String password);
  Future<AuthModel> loadAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<void> createAuthData(String email, String password) async {
    await storage.write(key: "email", value: email);
    await storage.write(key: "password", value: password);
  }

  @override
  Future<AuthModel> loadAuthData() async {
    String email = await storage.read(key: "email") ?? "no data";
    String password = await storage.read(key: "password") ?? "no data";
    if (email == "no data" || password == "no data") {
      throw CacheException();
    }
    return AuthModel(email: email, password: password);
  }
}