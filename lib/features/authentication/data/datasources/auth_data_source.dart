import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/core/functions.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class AuthDataSource {
  Future<void> addAuthDataToHousehold(String userID, String householdID);
  Future<String> createHouseholdAndAddAuthData(String userID, String householdTitle);
  Future<void> leaveHousehold(User user);
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
  Future<void> addAuthDataToHousehold(String userID, String householdID) async {
    try {
      final _ =  await householdRecordService.getOne(householdID);
    } catch(err) {
      throw NotFoundException();
    }
    final body = <String, dynamic>{
      "household": householdID,
    };
    try {
      final _ = await userRecordService.update(userID, body: body);
    } catch(err) {
      print(err);
      throw ServerException();
    }
  }

  @override
  Future<String> createHouseholdAndAddAuthData(String userID, String householdTitle) async {
    final body = <String, dynamic>{
      "title": householdTitle,
    };
    try {
      final result = await householdRecordService.create(body: body);
      await addAuthDataToHousehold(userID, result.id);
      return result.id;
    } catch(err) {
      print(err);
      throw ServerException();
    }

  }

  @override
  Future<void> leaveHousehold(User user) async {
    try {
      deleteUserFromHousehold(userRecordService, user.id);
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
      createWeeklyPoints(record.id);
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
      RecordModel user = authStore.model;

      //TODO: Point creation is needed but only when signing user in with oauth
      //createWeeklyPoints(user.id);
      return UserModel.fromJSON(user.data, user.id);

    } catch (err) {
      print(err);
      throw ServerException();
    }
  }

  @override
  void logout() async {
    authStore.clear();
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