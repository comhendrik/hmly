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
  Future<HouseholdModel> updateAllowedUsers(
      String userID,
      Household household,
      bool delete
      ) async {
    try {
      List<String> allowedUsers = household.allowedUsers;

      // Get the document reference
      DocumentReference docRef = FirebaseFirestore.instance.collection("households").doc(household.id);

      // Run the Firestore transaction to safely read and update the document
      await FirebaseFirestore.instance.runTransaction((transaction) async {

        if(delete) {
          allowedUsers.remove(userID);
          // Update the document with the modified list
          transaction.update(docRef, {"allowedUsers": allowedUsers});
        } else {
          // Get the snapshot of the document
          DocumentSnapshot docSnapshot = await transaction.get(docRef);

          // Check if the document exists
          if (docSnapshot.exists) {
            // Get the current list from the field (assumes it's a list of DocumentReference)
            List<dynamic>? currentList = docSnapshot.get("allowedUsers") as List<dynamic>?;

            DocumentReference refToModify = FirebaseFirestore.instance.collection("users").doc(userID);

            // Initialize the list if it's null
            currentList ??= [];

            // Check if the reference is already in the list
            bool refExists = currentList.any((item) => item == refToModify.path);

            if (!refExists) {
              currentList.add(refToModify.path);
              allowedUsers.add(userID);
              // Update the document with the modified list
              transaction.update(docRef, {"allowedUsers": currentList});
            }
          }
        }
      });

      return HouseholdModel(
          id: household.id,
          users: household.users,
          allowedUsers: allowedUsers);
    } on ClientException catch (err) {
      throw ServerException(response: err.response);
    } catch (e) {
      print(e.toString());
      throw UnknownException();
    }
  }
}