import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String id;
  final String name;
  final String householdID;
  final String email;

  const UserData({
    required this.id,
    required this.name,
    required this.householdID,
    required this.email,
  });

  factory UserData.fromJSON(Map<String, dynamic> json, String userID, String email) {
    return UserData(
      id: userID,
      name: json['username'],
      householdID: json['household'].id, //TODO: Vielleicht entfernen
      email: email
    );
  }

  @override
  List<Object> get props => [name, householdID, email];

}