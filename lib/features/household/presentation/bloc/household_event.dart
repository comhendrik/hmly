part of 'household_bloc.dart';


abstract class HouseholdEvent extends Equatable {
  const HouseholdEvent();

  @override
  List<Object> get props => [];
}

class LoadHouseholdEvent extends HouseholdEvent {
  final String householdID;

  const LoadHouseholdEvent({
    required this.householdID,
  });
}

class UpdateHouseholdTitleEvent extends HouseholdEvent {
  final String householdID;
  final String householdTitle;

  const UpdateHouseholdTitleEvent({
    required this.householdID,
    required this.householdTitle
  });
}

class DeleteAuthDataFromHouseholdEvent extends HouseholdEvent {
  final String userID;
  final String householdID;

  const DeleteAuthDataFromHouseholdEvent({
    required this.userID,
    required this.householdID,
  });
}

class UpdateAdminEvent extends HouseholdEvent {
  final String householdID;
  final String userID;


  const UpdateAdminEvent({
    required this.householdID,
    required this.userID,
  });
}

