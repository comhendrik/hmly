import 'package:household_organizer/core/entities/user.dart';

class UserModel extends User {

  const UserModel({
    required String id,
    required String username,
    required String householdId,
    required String email,
    required String name,
  }) : super (
    id: id,
    username: username,
    householdId: householdId,
    email: email,
    name: name
  );


  factory UserModel.fromJSON(Map<String, dynamic> json, String id) {
    return UserModel(
        id: id,
        username: json['username'],
        householdId: json['household'],
        email: json['email'],
        name: json['name']
    );
  }

}