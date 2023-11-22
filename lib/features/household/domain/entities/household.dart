import 'package:equatable/equatable.dart';
import 'package:hmly/core/entities/user.dart';

class Household extends Equatable {
  final String id;
  final String title;
  final List<User> users;
  final User admin;
  final List<String> allowedUsers;

  const Household({
    required this.id,
    required this.title,
    required this.users,
    required this.admin,
    required this.allowedUsers
  });

  @override
  List<Object> get props => [id, title, users, admin, allowedUsers];

}