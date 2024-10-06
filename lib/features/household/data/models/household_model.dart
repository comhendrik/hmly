import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:hmly/core/entities/user.dart';

class HouseholdModel extends Household {

  const HouseholdModel({
    required String id,
    required List<UserData> users,
    required List<String> allowedUsers
  }) : super (
    id: id,
    users: users,
    allowedUsers: allowedUsers
  );

}