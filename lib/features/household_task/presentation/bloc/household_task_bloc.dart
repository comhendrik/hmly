import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household_task/domain/entities/household_task.dart';
import 'package:hmly/features/household_task/domain/usecases/create_household_task.dart';
import 'package:hmly/features/household_task/domain/usecases/toggle_is_done_household_task.dart';
import '../../domain/usecases/get_all_tasks_for_household.dart';
import 'package:hmly/features/household_task/domain/usecases/update_household_task.dart';
import 'package:hmly/features/household_task/domain/usecases/delete_household_task.dart';

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
      if (event is GetAllTasksForHouseholdEvent)  {
        emit(HouseholdTaskLoading(msg: event.msg));
        final resultEither = await getTasks.execute(event.householdID);
        resultEither.fold(
            (failure) async {
              emit(HouseholdTaskError(failure: failure));
            },
            (tasks) {
              emit(HouseholdTaskLoaded(householdTaskList: tasks));
            }
        );
      } else if (event is CreateHouseholdTaskEvent) {
        emit(HouseholdTaskLoading(msg: event.msg));
        final resultEither = await createTask.execute(event.householdID, event.title, event.pointsWorth, event.dueTo);
        await resultEither.fold(
                (failure) async {
                  emit(HouseholdTaskError(failure: failure));
            },
                (task) async {
              final resultEitherTasks = await getTasks.execute(event.householdID);
              await resultEitherTasks.fold(
                      (failure) async {
                        emit(HouseholdTaskError(failure: failure));
                  },
                      (tasks) async {
                    emit(HouseholdTaskLoaded(householdTaskList: tasks));
                  }
              );
            }
        );


      } else if (event is ToggleIsDoneHouseholdTaskEvent) {


        emit(HouseholdTaskLoading(msg: event.msg));
        final resultEither = await toggleIsDoneHouseholdTask.execute(event.task, event.userID);
        await resultEither.fold(
          (failure) async {
            emit(HouseholdTaskError(failure: failure));
          },
          (_) async {
            final resultEitherTasks = await getTasks.execute(event.householdID);
            await resultEitherTasks.fold(
                    (failure) async {
                      emit(HouseholdTaskError(failure: failure));
                },
                    (tasks) async {
                  emit(HouseholdTaskLoaded(householdTaskList: tasks));
                }
            );
          }
        );


      } else if (event is DeleteHouseholdTaskEvent) {


        emit(HouseholdTaskLoading(msg: event.msg));
        final resultEither = await deleteTask.execute(event.taskId);
        await resultEither.fold(
                (failure) async {
                  emit(HouseholdTaskError(failure: failure));
            },
                (_) async {
              final resultEitherTasks = await getTasks.execute(event.householdID);
              await resultEitherTasks.fold(
                      (failure) async {
                        emit(HouseholdTaskError(failure: failure));
                  },
                      (tasks) async {
                    emit(HouseholdTaskLoaded(householdTaskList: tasks));
                  }
              );
            });


      } else if (event is UpdateHouseholdTaskEvent) {


        emit(HouseholdTaskLoading(msg: event.msg));
        final resultEither = await updateTask.execute(event.task, event.updateData);
        await resultEither.fold(
          (failure) async {
            emit(HouseholdTaskError(failure: failure));
          },
          (_) async {
            final resultEitherTasks = await getTasks.execute(event.householdID);
            await resultEitherTasks.fold(
              (failure) async {
                emit(HouseholdTaskError(failure: failure));
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
