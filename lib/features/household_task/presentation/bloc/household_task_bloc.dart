import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/domain/usecases/create_household_task.dart';
import 'package:household_organizer/features/household_task/domain/usecases/toggle_is_done_household_task.dart';
import '../../domain/usecases/get_all_tasks_for_household.dart';
import 'package:household_organizer/features/household_task/domain/usecases/update_household_task.dart';
import 'package:household_organizer/features/household_task/domain/usecases/delete_household_task.dart';

part 'household_task_event.dart';
part 'household_task_state.dart';

class HouseholdTaskBloc extends Bloc<HouseholdTaskEvent, HouseholdTaskState> {

  final GetAllTasksForHousehold getTasks;
  final CreateHouseholdTask createTask;
  final ToggleIsDoneHouseholdTask toggleIsDoneHouseholdTask;
  final UpdateHouseholdTask updateTask;
  final DeleteHouseholdTask deleteTask;
  HouseholdTaskBloc({
    required this.getTasks,
    required this.createTask,
    required this.toggleIsDoneHouseholdTask,
    required this.updateTask,
    required this.deleteTask
  }) : super(HouseholdTaskInitial()) {
    on<HouseholdTaskEvent>((event, emit) async {
      emit(HouseholdTaskInitial());
      if (event is GetAllTasksForHouseholdEvent)  {


        emit(HouseholdTaskLoading());
        final resultEither = await getTasks.execute(event.householdID);
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
        final resultEither = await createTask.execute(event.householdID, event.title, event.pointsWorth, event.dueTo);
        await resultEither.fold(
                (failure) async {
              emit(const HouseholdTaskError(errorMsg: 'Server Failure'));
            },
                (task) async {
              final resultEitherTasks = await getTasks.execute(event.householdID);
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


      } else if (event is ToggleIsDoneHouseholdTaskEvent) {


        emit(HouseholdTaskLoading());
        final resultEither = await toggleIsDoneHouseholdTask.execute(event.task, event.userID);
        await resultEither.fold(
          (failure) async {
            emit(const HouseholdTaskError(errorMsg: 'Server Failure'));
          },
          (_) async {
            final resultEitherTasks = await getTasks.execute(event.householdID);
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


      } else if (event is DeleteHouseholdTaskEvent) {


        emit(HouseholdTaskLoading());
        final resultEither = await deleteTask.execute(event.taskId);
        await resultEither.fold(
                (failure) async {
              emit(const HouseholdTaskError(errorMsg: 'Server Failure'));
            },
                (_) async {
              final resultEitherTasks = await getTasks.execute(event.householdID);
              await resultEitherTasks.fold(
                      (failure) async {
                    emit(const HouseholdTaskError(errorMsg: 'Server Failure'));
                  },
                      (tasks) async {
                    emit(HouseholdTaskLoaded(householdTaskList: tasks));
                  }
              );
            });


      } else if (event is UpdateHouseholdTaskEvent) {


        emit(HouseholdTaskLoading());
        final resultEither = await updateTask.execute(event.task, event.updateData);
        await resultEither.fold(
          (failure) async {
            emit(const HouseholdTaskError(errorMsg: 'Server Failure while updating Task'));
          },
          (_) async {
            final resultEitherTasks = await getTasks.execute(event.householdID);
            await resultEitherTasks.fold(
              (failure) async {
                emit(const HouseholdTaskError(errorMsg: 'Server Failure while reloading all Tasks'));
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
