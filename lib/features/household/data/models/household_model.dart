import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:hmly/core/entities/user.dart';

class HouseholdModel extends Household {

  const HouseholdModel({
    required String id,
    required List<UserData> users,
    required List<String> allowedUsers
  }) : super (
    id: id,
    users: users,
    allowedUsers: allowedUsers
  );


  factory HouseholdModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    return HouseholdModel(id: snap.id, users: [
      UserData(id: "id", name: "name", householdID: "householdID", email: "email", verified: false)
    ], allowedUsers: [
      "fasdfs"
    ]);
  }

  factory HouseholdModel.fromJSON(Map<String, dynamic> json, String id, List<UserData> users, Map<String, dynamic> admin, String adminID) {
    return HouseholdModel(
      id: id,
      users: users,
      allowedUsers: [...json["allowed_users"]] //casts List<dynamic> into List<String
    );
  }

}