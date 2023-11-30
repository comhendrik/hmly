part of 'household_task_bloc.dart';

abstract class HouseholdTaskEvent extends Equatable {
  const HouseholdTaskEvent();

  @override
  List<Object> get props => [];
}

class GetAllTasksForHouseholdEvent extends HouseholdTaskEvent {
  final String householdID;
  final String msg = "Fetch all Tasks";

  const GetAllTasksForHouseholdEvent({
    required this.householdID,
  });
}

class CreateHouseholdTaskEvent extends HouseholdTaskEvent {
  final String householdID;
  final String title;
  final int pointsWorth;
  final DateTime dueTo;
  final String msg = "Create new Tasks";

  const CreateHouseholdTaskEvent({
    required this.householdID,
    required this.title,
    required this.pointsWorth,
    required this.dueTo
  });
}

class ToggleIsDoneHouseholdTaskEvent extends HouseholdTaskEvent {
  final HouseholdTask task;
  final String householdID;
  final String userID;
  final String msg = "Changing state of Task";

  const ToggleIsDoneHouseholdTaskEvent({
    required this.task,
    required this.householdID,
    required this.userID,
  });
}

class DeleteHouseholdTaskEvent extends HouseholdTaskEvent {
  final String taskId;
  final String householdID;
  final String msg = "Deleting Task";

  const DeleteHouseholdTaskEvent({
    required this.taskId,
    required this.householdID
  });
}

class UpdateHouseholdTaskEvent extends HouseholdTaskEvent {
  final HouseholdTask task;
  final Map<String, dynamic> updateData;
  final String householdID;
  final String msg = "Updating Task";

  const UpdateHouseholdTaskEvent({
    required this.task,
    required this.updateData,
    required this.householdID
  });
}

class LogoutHouseholdTaskEvent extends HouseholdTaskEvent {}
