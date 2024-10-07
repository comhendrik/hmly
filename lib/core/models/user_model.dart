import 'package:hmly/core/entities/user.dart';

class UserDataModel extends UserData {

  const UserDataModel({
    required String id,
    required String name,
    required String householdID,
    required String email,
    required bool veriefied,
  }) : super (
      id: id,
      name: name,
      householdID: householdID,
      email: email,
      verified: veriefied
  );


  factory UserDataModel.fromJSON(Map<String, dynamic> json, String userID, String email, bool verified) {
    return UserDataModel(
      id: userID,
      name: json['name'],
      householdID: json['household']?.id ?? "",
      email: email,
      veriefied: verified
    );
  }

}