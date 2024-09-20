import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/features/household/data/models/household_model.dart';
import 'package:hmly/core/models/user_model.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class HouseholdDataSource {
  Future<HouseholdModel> loadHousehold(String householdID);
  Future<void> deleteAuthDataFromHousehold(String userID);
  Future<void> deleteHousehold(String householdID);
  Future<HouseholdModel> updateAllowedUsers(String userID, Household household, bool delete);
}

class HouseholdDataSourceImpl implements HouseholdDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  HouseholdDataSourceImpl();

  @override
  Future<HouseholdModel> loadHousehold(String householdID) async {
    try {

      final householdRef = firestore.collection("households").doc(householdID);

      final snap = await householdRef.get();

      final users = await firestore.collection("users").where("household", isEqualTo: householdRef).get();
      List<UserData> userList = [];
      for (final user in users.docs) {
        userList.add(
          UserData(
              id: user.id,
              name: user.data()["name"] ?? "no name",
              householdID: householdID,
              email: user.data()["email"] ?? "no email",
              verified: false //false because it is not neccassary for this
          ),
        );
      }

      List<String> allowedUsers = [];

      for(final allowedUser in snap.data()?["allowedUsers"] as List<dynamic>) {
        allowedUsers.add(allowedUser.id);
      }
      return HouseholdModel(
          id: householdID,
          users: userList,
          allowedUsers: allowedUsers
      );
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (err) {
      print(err.toString());
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteAuthDataFromHousehold(String userID) async {
    try {
      await firestore.collection("users").doc(userID).set({
        "household": FieldValue.delete(), // Use FieldValue.delete() to remove the field
      });
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteHousehold(String householdID) async {
    try {
      await firestore.collection("households").doc(householdID).delete();
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<HouseholdModel> updateAllowedUsers(String userID, Household household, bool delete) async {


    //TODO: Build for firebase
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
      //final result = await householdRecordService.update(household.id, body: body);

      return HouseholdModel(
          id: household.id,
          users: household.users, allowedUsers: household.allowedUsers);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }
}