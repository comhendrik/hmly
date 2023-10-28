import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household/data/models/household_model.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:pocketbase/pocketbase.dart';


//TODO: Maybe put this household feature into authentication feature
abstract class HouseholdRemoteDataSource {
  Future<HouseholdModel> loadHousehold(String householdID);
  Future<HouseholdModel> updateHouseholdTitle(String householdID, String title);
  Future<void> deleteAuthDataFromHousehold(String userID);
  Future<HouseholdModel> updateAdmin(String householdID, String userID);
}

class HouseholdRemoteDataSourceImpl implements HouseholdRemoteDataSource {
  final RecordService userRecordService;
  final RecordService householdRecordService;

  HouseholdRemoteDataSourceImpl({
    required this.userRecordService,
    required this.householdRecordService,
  });

  @override
  Future<HouseholdModel> loadHousehold(String householdID) async {
    try {
      final result = await householdRecordService.getOne(householdID, expand: 'admin');
      final users = await userRecordService.getFullList(filter: 'household="$householdID"');
      List<User> userList = [];
      for (final user in users) {
        final userResult = await userRecordService.getOne(user.id);
        userList.add(User.fromJSON(userResult.data, userResult.id));
      }
      return HouseholdModel.fromJSON(result.data, result.id, userList, result.expand['admin']!.first.data, result.expand['admin']!.first.id);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
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
      final users = await userRecordService.getFullList(filter: 'household="$householdID"');
      List<User> userList = [];
      for (final user in users) {
        final userResult = await userRecordService.getOne(user.id);
        userList.add(UserModel.fromJSON(userResult.data, user.id));
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
      final body = <String, dynamic> {
        "admin" : userID,
      };
      final result = await householdRecordService.update(householdID, body: body);
      final admin = await userRecordService.getOne(userID);
      final users = await userRecordService.getFullList(filter: 'household="$householdID"');
      List<User> userList = [];
      for (final user in users) {
        final userResult = await userRecordService.getOne(user.id);
        userList.add(UserModel.fromJSON(userResult.data, user.id));
      }

      return HouseholdModel.fromJSON(result.data, result.id, userList, admin.data, admin.id);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }
}