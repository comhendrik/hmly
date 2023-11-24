part of 'household_bloc.dart';


abstract class HouseholdEvent extends Equatable {
  const HouseholdEvent();

  @override
  List<Object> get props => [];
}

class LoadHouseholdEvent extends HouseholdEvent {
  final String householdID;
  final String msg = "Household is Loaded";

  const LoadHouseholdEvent({
    required this.householdID,
  });
}

class UpdateHouseholdTitleEvent extends HouseholdEvent {
  final String householdID;
  final String householdTitle;
  final String msg = "Household Title is updated";

  const UpdateHouseholdTitleEvent({
    required this.householdID,
    required this.householdTitle
  });
}

class DeleteAuthDataFromHouseholdEvent extends HouseholdEvent {
  final String userID;
  final Household household;
  final String msg = "User is getting deleted from household";

  const DeleteAuthDataFromHouseholdEvent({
    required this.userID,
    required this.household,
  });
}

class UpdateAdminEvent extends HouseholdEvent {
  final String householdID;
  final String userID;
  final String msg = "Admin is getting updated";


  const UpdateAdminEvent({
    required this.householdID,
    required this.userID,
  });
}

class DeleteHouseholdEvent extends HouseholdEvent {
  final String householdID;

  const DeleteHouseholdEvent({
    required this.householdID,
  });
}


class AddIDToAllowedUsersEvent extends HouseholdEvent {
  final String userID;
  final Household household;

  const AddIDToAllowedUsersEvent({
    required this.userID,
    required this.household
  });
}

