import 'package:equatable/equatable.dart';
import 'package:hmly/core/entities/user.dart';

class Household extends Equatable {
  final String id;
  final List<UserData> users;
  final UserData admin;
  final List<String> allowedUsers;

  const Household({
    required this.id,
    required this.users,
    required this.admin,
    required this.allowedUsers
  });

  @override
  List<Object> get props => [id, users, admin, allowedUsers];

}