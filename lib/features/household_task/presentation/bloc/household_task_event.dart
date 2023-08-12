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

  const CreateHouseholdTaskEvent({
    required this.householdId,
    required this.title,
    required this.pointsWorth
  });
}
