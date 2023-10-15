import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/core/entities/user.dart';

class HouseholdModel extends Household {

  const HouseholdModel({
    required String id,
    required String title,
    required List<User> users,
    required User admin,
  }) : super (
    id: id,
    title: title,
    users: users,
    admin: admin
  );


  factory HouseholdModel.fromJSON(Map<String, dynamic> json, String id, List<User> users, Map<String, dynamic> admin, String adminID) {
    return HouseholdModel(
      id: id,
      title: json['title'],
      users: users,
      admin: User.fromJSON(admin, adminID)
    );
  }

}