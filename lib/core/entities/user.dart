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

  //TODO: Implementing use of WeeklyPoints!!!
  @override
  List<Object> get props => [id, username, householdId, email, name];

}