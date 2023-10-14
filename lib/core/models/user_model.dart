import 'package:household_organizer/core/entities/user.dart';

class UserModel extends User {

  const UserModel({
    required String id,
    required String username,
    required String householdID,
    required String email,
    required String name,
  }) : super (
    id: id,
    username: username,
    householdID: householdID,
    email: email,
    name: name
  );


  factory UserModel.fromJSON(Map<String, dynamic> json, String id) {
    return UserModel(
        id: id,
        username: json['username'],
        householdID: json['household'],
        email: json['email'],
        name: json['name']
    );
  }

}