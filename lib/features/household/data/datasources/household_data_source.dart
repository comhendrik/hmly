import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/features/household/data/models/household_model.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
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
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
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
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteHousehold(String householdID) async {
    try {
      await firestore.collection("households").doc(householdID).delete();
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
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

      //TODO: rebuild this to .contains if question

      for(UserData ur in household.users) {
        if(ur.id == userID) return HouseholdModel(id: household.id, users: household.users, allowedUsers: household.allowedUsers);
      }


      List<String> allowedUsers = household.allowedUsers;

      // Get the document reference
      DocumentReference docRef = firestore.collection("households").doc(household.id);

      // Run the Firestore transaction to safely read and update the document
      await firestore.runTransaction((transaction) async {

        // Get the snapshot of the document
        DocumentSnapshot docSnapshot = await transaction.get(docRef);

        // Check if the document exists
        if (docSnapshot.exists) {
          // Get the current list from the field (assumes it's a list of DocumentReference)
          List<dynamic>? currentList = docSnapshot.get("allowedUsers") as List<dynamic>?;

          DocumentReference refToModify = firestore.collection("users").doc(userID);

          // Initialize the list if it's null
          currentList ??= [];

          if(delete) {
            currentList.remove(refToModify.path);
            allowedUsers.remove(userID);
            // Update the document with the modified list
            transaction.update(docRef, {"allowedUsers": currentList});
          } else {
            currentList.add(refToModify.path);
            allowedUsers.add(userID);
            // Update the document with the modified list
            transaction.update(docRef, {"allowedUsers": currentList});
          }


        }
      });

      return HouseholdModel(
          id: household.id,
          users: household.users,
          allowedUsers: allowedUsers);
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (e) {
      throw UnknownException();
    }
  }
}