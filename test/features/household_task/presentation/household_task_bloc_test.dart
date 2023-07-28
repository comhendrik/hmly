import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/domain/usecases/create_household_task.dart';
import 'package:household_organizer/features/household_task/domain/usecases/get_all_tasks_for_household.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetAllTasksForHousehold extends Mock implements GetAllTasksForHousehold {}

class MockCreateHouseholdTask extends Mock implements CreateHouseholdTask {}

void main() {
  late MockGetAllTasksForHousehold getAllTasksForHousehold;
  late MockCreateHouseholdTask createHouseholdTask;
  late HouseholdTaskBloc bloc;

  setUpAll(() {
    getAllTasksForHousehold = MockGetAllTasksForHousehold();
    createHouseholdTask = MockCreateHouseholdTask();
    bloc = HouseholdTaskBloc(getTasks: getAllTasksForHousehold, createTask: createHouseholdTask);
  });

  group('getAllTasksForHousehold', () {

    final tHouseholdTask = HouseholdTask(id: '0', title: 'Waschen', date: DateTime(2023, 1,11), isDone: false);
    final tHouseholdTask1 = HouseholdTask(id: '1', title: 'Waschen',date: null, isDone: false);
    final tHouseholdTaskList = [tHouseholdTask, tHouseholdTask1];

    test(
        'should get data from getNews use case',
            () async {
          when(() => getAllTasksForHousehold.execute()).thenAnswer((_) async => Right(tHouseholdTaskList));

          bloc.add(GetAllTasksForHouseholdEvent());

          await untilCalled(() => getAllTasksForHousehold.execute());

          verify(() => getAllTasksForHousehold.execute());


        }
    );

    test(
        'should emit [Initial(), Loading(), Loaded()] when the server request is succesful',
            () async {

          when(() => getAllTasksForHousehold.execute()).thenAnswer((_) async => Right(tHouseholdTaskList));


          expectLater(bloc.stream, emitsInOrder(
              [
                HouseholdTaskInitial(),
                HouseholdTaskLoading(),
                HouseholdTaskLoaded(householdTaskList: tHouseholdTaskList)
              ]
          ));

          bloc.add(GetAllTasksForHouseholdEvent());

        }
    );

    test(
        'should emit [Initial(), Loading(), Error()] when the request is unsuccessful',
            () async {

          when(() => getAllTasksForHousehold.execute()).thenAnswer((_) async => Left(ServerFailure()));


          expectLater(bloc.stream, emitsInOrder(
              [
                HouseholdTaskInitial(),
                HouseholdTaskLoading(),
                const HouseholdTaskError(errorMsg: 'Server Failure')
              ]
          ));

          bloc.add(GetAllTasksForHouseholdEvent());

        }
    );
  });
}
