import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import '../../domain/usecases/get_all_tasks_for_household.dart';

part 'household_task_event.dart';
part 'household_task_state.dart';

class HouseholdTaskBloc extends Bloc<HouseholdTaskEvent, HouseholdTaskState> {

  final GetAllTasksForHousehold getTasks;
  HouseholdTaskBloc({required this.getTasks}) : super(HouseholdTaskInitial()) {
    on<HouseholdTaskEvent>((event, emit) async {
      if (event is GetAllTasksForHouseholdEvent)  {
        emit(HouseholdTaskLoading());
        final resultEither = await getTasks.execute();
        resultEither.fold(
            (failure) async {
              emit(const HouseholdTaskError(errorMsg: 'Server Failure'));
            },
            (tasks) {
              emit(HouseholdTaskLoaded(householdTaskList: tasks));
            }
        );
      }
    });
  }
}
