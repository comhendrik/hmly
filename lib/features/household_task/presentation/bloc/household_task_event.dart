part of 'household_task_bloc.dart';


abstract class HouseholdTaskEvent extends Equatable {
  const HouseholdTaskEvent();

  @override
  List<Object> get props => [];
}

class GetAllTasksForHouseholdEvent extends HouseholdTaskEvent {
  final String householdID;
  final BuildContext context;
  final String msg;

  GetAllTasksForHouseholdEvent({
    required this.householdID,
    required this.context
  }) : msg = AppLocalizations.of(context)!.getAllTasksForHouseholdEvent;
}

class CreateHouseholdTaskEvent extends HouseholdTaskEvent {
  final String householdID;
  final String title;
  final int pointsWorth;
  final DateTime dueTo;
  final BuildContext context;
  final String msg;

  CreateHouseholdTaskEvent({
    required this.householdID,
    required this.title,
    required this.pointsWorth,
    required this.dueTo,
    required this.context
  }) : msg = AppLocalizations.of(context)!.createHouseholdTaskEvent;
}

class ToggleIsDoneHouseholdTaskEvent extends HouseholdTaskEvent {
  final HouseholdTask task;
  final String householdID;
  final String userID;
  final BuildContext context;
  final String msg;

  ToggleIsDoneHouseholdTaskEvent({
    required this.task,
    required this.householdID,
    required this.userID,
    required this.context
  }) : msg = AppLocalizations.of(context)!.toggleIsDoneHouseholdTaskEvent;
}

class DeleteHouseholdTaskEvent extends HouseholdTaskEvent {
  final String taskId;
  final String householdID;
  final BuildContext context;
  final String msg;

  DeleteHouseholdTaskEvent({
    required this.taskId,
    required this.householdID,
    required this.context
  }) : msg = AppLocalizations.of(context)!.deleteHouseholdTaskEvent;
}

class UpdateHouseholdTaskEvent extends HouseholdTaskEvent {
  final HouseholdTask task;
  final Map<String, dynamic> updateData;
  final String householdID;
  final BuildContext context;
  final String msg;

  UpdateHouseholdTaskEvent({
    required this.task,
    required this.updateData,
    required this.householdID,
    required this.context
  }) : msg = AppLocalizations.of(context)!.updateHouseholdTitleEvent;
}

class LogoutHouseholdTaskEvent extends HouseholdTaskEvent {}
