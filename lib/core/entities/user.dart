import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String householdId;
  final String email;
  final String name;

  const User({
    required this.id,
    required this.username,
    required this.householdId,
    required this.email,
    required this.name
  });

  factory User.fromJSON(Map<String, dynamic> json, String id) {
    return User(
        id: id,
        username: json['username'],
        householdId: json['household'],
        email: json['email'],
        name: json['name']
    );
  }

  @override
  List<Object> get props => [id, username, householdId, email, name];

}