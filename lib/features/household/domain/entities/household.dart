import 'package:equatable/equatable.dart';
import 'package:household_organizer/core/entities/user.dart';

class Household extends Equatable {
  final String id;
  final String title;
  final List<User> users;

  const Household({
    required this.id,
    required this.title,
    required this.users,
  });

  @override
  List<Object> get props => [id, title, users];

}