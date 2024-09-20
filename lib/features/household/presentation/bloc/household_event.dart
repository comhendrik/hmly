part of 'household_bloc.dart';


abstract class HouseholdEvent extends Equatable {
  const HouseholdEvent();

  @override
  List<Object> get props => [];
}

class LoadHouseholdEvent extends HouseholdEvent {
  final String householdID;
  final BuildContext context;
  final String msg;

  LoadHouseholdEvent({
    required this.householdID,
    required this.context
  }) : msg = AppLocalizations.of(context)!.loadHouseholdEvent;
}

class DeleteAuthDataFromHouseholdEvent extends HouseholdEvent {
  final String userID;
  final Household household;
  final BuildContext context;
  final String msg;

  DeleteAuthDataFromHouseholdEvent({
    required this.userID,
    required this.household,
    required this.context
  }) :  msg = AppLocalizations.of(context)!.deleteAuthDataFromHouseholdEvent;
}

class DeleteHouseholdEvent extends HouseholdEvent {
  final String householdID;

  const DeleteHouseholdEvent({
    required this.householdID,
  });
}


class UpdateAllowedUsersEvent extends HouseholdEvent {
  final String userID;
  final Household household;
  final bool delete;
  final BuildContext context;
  final String msg;

  UpdateAllowedUsersEvent({
    required this.userID,
    required this.household,
    required this.delete,
    required this.context
  }) : msg = AppLocalizations.of(context)!.updateAllowedUsersEvent;
}

class LogoutHouseholdEvent extends HouseholdEvent {}

