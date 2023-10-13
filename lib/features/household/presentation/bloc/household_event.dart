part of 'household_bloc.dart';


abstract class HouseholdEvent extends Equatable {
  const HouseholdEvent();

  @override
  List<Object> get props => [];
}

class LoadHouseholdEvent extends HouseholdEvent {
  final String householdId;

  const LoadHouseholdEvent({
    required this.householdId,
  });
}

class UpdateHouseholdTitleEvent extends HouseholdEvent {
  final String householdId;
  final String householdTitle;

  const UpdateHouseholdTitleEvent({
    required this.householdId,
    required this.householdTitle
  });
}

class DeleteAuthDataFromHouseholdEvent extends HouseholdEvent {
  final String userID;
  final String householdId;

  const DeleteAuthDataFromHouseholdEvent({
    required this.userID,
    required this.householdId,
  });
}

