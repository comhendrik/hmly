import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:hmly/core/entities/user.dart';

class HouseholdModel extends Household {

  const HouseholdModel({
    required String id,
    required String title,
    required List<User> users,
    required User admin,
    required List<String> allowedUsers
  }) : super (
    id: id,
    title: title,
    users: users,
    admin: admin,
    allowedUsers: allowedUsers
  );


  factory HouseholdModel.fromJSON(Map<String, dynamic> json, String id, List<User> users, Map<String, dynamic> admin, String adminID) {
    return HouseholdModel(
      id: id,
      title: json['title'],
      users: users,
      admin: User.fromJSON(admin, adminID),
      allowedUsers: [...json["allowed_users"]] //casts List<dynamic> into List<String
    );
  }

}