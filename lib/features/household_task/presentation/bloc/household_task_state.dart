part of 'household_task_bloc.dart';

abstract class HouseholdTaskState extends Equatable {
  const HouseholdTaskState();
}

class HouseholdTaskInitial extends HouseholdTaskState {
  @override
  List<Object> get props => [];
}

class HouseholdTaskLoading extends HouseholdTaskState {
  @override
  List<Object> get props => [];
}

class HouseholdTaskLoaded extends HouseholdTaskState {
  final List<HouseholdTask> householdTaskList;
  const HouseholdTaskLoaded({required this.householdTaskList});

  @override
  List<Object> get props => [];
}

class HouseholdTaskError extends HouseholdTaskState {
  final Failure failure;
  const HouseholdTaskError({
    required this.failure
  });

  @override
  List<Object> get props => [];
}
