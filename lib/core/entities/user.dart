import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String id;
  final String name;
  final String householdID;
  final String email;
  final bool verified;

  const UserData({
    required this.id,
    required this.name,
    required this.householdID,
    required this.email,
    required this.verified
  });

  factory UserData.fromJSON(Map<String, dynamic> json, String userID, String email, bool verified) {
    return UserData(
        id: userID,
        name: json['username'],
        householdID: json['household'].id,
        email: email,
        verified: verified
    );
  }

  @override
  List<Object> get props => [name, householdID, email];

}