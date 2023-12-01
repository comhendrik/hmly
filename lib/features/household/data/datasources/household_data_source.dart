import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/features/household/data/models/household_model.dart';
import 'package:hmly/core/models/user_model.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:pocketbase/pocketbase.dart';


abstract class HouseholdDataSource {
  Future<HouseholdModel> loadHousehold(String householdID);
  Future<HouseholdModel> updateHouseholdTitle(String householdID, String title);
  Future<void> deleteAuthDataFromHousehold(String userID);
  Future<HouseholdModel> updateAdmin(String householdID, String userID);
  Future<void> deleteHousehold(String householdID);
  Future<HouseholdModel> updateAllowedUsers(String userID, Household household, bool delete);
}

class HouseholdDataSourceImpl implements HouseholdDataSource {
  final RecordService userRecordService;
  final RecordService householdRecordService;
  final RecordService taskRecordService;

  HouseholdDataSourceImpl({
    required this.userRecordService,
    required this.householdRecordService,
    required this.taskRecordService
  });

  @override
  Future<HouseholdModel> loadHousehold(String householdID) async {
    try {
      final result = await householdRecordService.getOne(householdID, expand: 'admin');
      final users = await userRecordService.getFullList(filter: 'household="$householdID"');
      List<User> userList = [];
      for (final user in users) {
        userList.add(User.fromJSON(user.data, user.id));
      }
      return HouseholdModel.fromJSON(result.data, result.id, userList, result.expand['admin']!.first.data, result.expand['admin']!.first.id);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (err) {
      throw UnknownException();
    }
  }

  @override
  Future<HouseholdModel> updateHouseholdTitle(String householdID, String householdTitle) async {
    try {
      final body = <String, dynamic> {
        "title" : householdTitle,
      };
      final result = await householdRecordService.update(householdID, body: body, expand: 'admin');
      //TODO: Maybe no new call of users, because data is already there
      final users = await userRecordService.getFullList(filter: 'household="$householdID"');
      List<User> userList = [];
      for (final user in users) {
        userList.add(UserModel.fromJSON(user.data, user.id));
      }

      return HouseholdModel.fromJSON(result.data, result.id, userList, result.expand['admin']!.first.data, result.expand['admin']!.first.id);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<void> deleteAuthDataFromHousehold(String userID) async {

    try {
      final body = <String, dynamic> {
        "household" : ""
      };
      final _ = await userRecordService.update(userID, body: body);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<HouseholdModel> updateAdmin(String householdID, String userID) async {
    try {
      final admin = await userRecordService.getOne(userID);
      if (admin.data['household'] == '') {
        //TODO: CustomException
        throw Exception("User is already not in household");
      }
      final body = <String, dynamic> {
        "admin" : userID,
      };
      final result = await householdRecordService.update(householdID, body: body);
      final users = await userRecordService.getFullList(filter: 'household="$householdID"');
      List<User> userList = [];
      for (final user in users) {
        userList.add(UserModel.fromJSON(user.data, user.id));
      }

      return HouseholdModel.fromJSON(result.data, result.id, userList, admin.data, admin.id);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteHousehold(String householdID) async {
    try {
      final tasks = await taskRecordService.getFullList(filter: 'household="$householdID"');
      for (RecordModel task in tasks) {
        await taskRecordService.delete(task.id);
      }
      await householdRecordService.delete(householdID);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<HouseholdModel> updateAllowedUsers(String userID, Household household, bool delete) async {

    try {
      List<String> allowedUsers = household.allowedUsers;
      if(!delete) {
        allowedUsers.add(userID);
      } else {
        for (var i = 0; i < allowedUsers.length; i++) {
          if (allowedUsers[i] == userID) {
            allowedUsers.removeAt(i);

            break;
          }
        }
      }

      final body = <String, dynamic> {
        "allowed_users" : allowedUsers
      };
      final result = await householdRecordService.update(household.id, body: body);
      return HouseholdModel(id: household.id, title: household.title, users: household.users, admin: household.admin, allowedUsers: [...result.data["allowed_users"]]);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }
}