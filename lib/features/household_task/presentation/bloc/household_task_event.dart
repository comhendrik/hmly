part of 'household_task_bloc.dart';

abstract class HouseholdTaskEvent extends Equatable {
  const HouseholdTaskEvent();

  @override
  List<Object> get props => [];
}

class GetAllTasksForHouseholdEvent extends HouseholdTaskEvent {
  final String householdId;

  const GetAllTasksForHouseholdEvent({
    required this.householdId,
  });
}

class CreateHouseholdTaskEvent extends HouseholdTaskEvent {
  final String householdId;
  final String title;
  final int pointsWorth;
  final DateTime dueTo;

  const CreateHouseholdTaskEvent({
    required this.householdId,
    required this.title,
    required this.pointsWorth,
    required this.dueTo
  });
}

class UpdateHouseholdTaskEvent extends HouseholdTaskEvent {
  final HouseholdTask task;
  final String householdId;
  final String userId;

  const UpdateHouseholdTaskEvent({
    required this.task,
    required this.householdId,
    required this.userId,
  });
}

class DeleteHouseholdTaskEvent extends HouseholdTaskEvent {
  final String taskId;
  final String householdId;

  const DeleteHouseholdTaskEvent({
    required this.taskId,
    required this.householdId
  });
}
