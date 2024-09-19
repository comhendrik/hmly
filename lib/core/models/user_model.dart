import 'package:hmly/core/entities/user.dart';

class UserDataModel extends UserData {

  const UserDataModel({
    required String id,
    required String name,
    required String householdID,
    required String email,
  }) : super (
    id: id,
    name: name,
    householdID: householdID,
    email: email
  );


  factory UserDataModel.fromJSON(Map<String, dynamic> json, String userID, String email) {
    return UserDataModel(
      id: userID,
      name: json['name'],
      householdID: json['household']?.id ?? "", //TODO: vielleicht entfernen und nicht aus json machen
      email: email,
    );
  }

}