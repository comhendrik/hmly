import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/entities/user.dart';

class HouseholdModel extends Household {

  const HouseholdModel({
    required String id,
    required String title,
    required List<User> users,
    required int minWeeklyPoints,
  }) : super (
    id: id,
    title: title,
    users: users,
    minWeeklyPoints: minWeeklyPoints
  );


  factory HouseholdModel.fromJSON(Map<String, dynamic> json, String id, List<User> users) {
    return HouseholdModel(
      id: id,
      title: json['title'],
      users: users,
      minWeeklyPoints: json['minWeeklyPoints']
    );
  }

}