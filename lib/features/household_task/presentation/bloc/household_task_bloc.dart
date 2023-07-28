import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/domain/usecases/create_household_task.dart';
import '../../domain/usecases/get_all_tasks_for_household.dart';

part 'household_task_event.dart';
part 'household_task_state.dart';

class HouseholdTaskBloc extends Bloc<HouseholdTaskEvent, HouseholdTaskState> {

  final GetAllTasksForHousehold getTasks;
  final CreateHouseholdTask createTask;
  HouseholdTaskBloc({required this.getTasks, required this.createTask}) : super(HouseholdTaskInitial()) {
    on<HouseholdTaskEvent>((event, emit) async {
      emit(HouseholdTaskInitial());
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
      } else if (event is CreateHouseholdTaskEvent) {
        emit(HouseholdTaskLoading());
        final resultEither = await createTask.execute(event.title, event.pointsWorth);
        await resultEither.fold(
                (failure) async {
              emit(const HouseholdTaskError(errorMsg: 'Server Failure'));
            },
                (task) async {
              final resultEitherTasks = await getTasks.execute();
              await resultEitherTasks.fold(
                      (failure) async {
                    emit(const HouseholdTaskError(errorMsg: 'Server Failure'));
                  },
                      (tasks) async {
                    emit(HouseholdTaskLoaded(householdTaskList: tasks));
                  }
              );
            }
        );
      }
    });
  }
}
