import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/domain/usecases/get_all_tasks_for_household.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetAllTasksForHousehold extends Mock implements GetAllTasksForHousehold {}

void main() {
  late MockGetAllTasksForHousehold usecase;
  late HouseholdTaskBloc bloc;

  setUpAll(() {
    usecase = MockGetAllTasksForHousehold();
    bloc = HouseholdTaskBloc(getTasks: usecase);
  });

  group('getAllTasksForHousehold', () {

    final tHouseholdTask = HouseholdTask(id: '0', title: 'Waschen', date: DateTime(2023, 1,11), isDone: false);
    final tHouseholdTask1 = HouseholdTask(id: '1', title: 'Waschen',date: null, isDone: false);
    final tHouseholdTaskList = [tHouseholdTask, tHouseholdTask1];

    test(
        'should get data from getNews use case',
            () async {
          when(() => usecase.execute()).thenAnswer((_) async => Right(tHouseholdTaskList));

          bloc.add(GetAllTasksForHouseholdEvent());

          await untilCalled(() => usecase.execute());

          verify(() => usecase.execute());


        }
    );

    test(
        'should emit [Initial(), Loading(), Loaded()] when the server request is succesful',
            () async {

          when(() => usecase.execute()).thenAnswer((_) async => Right(tHouseholdTaskList));


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

          when(() => usecase.execute()).thenAnswer((_) async => Left(ServerFailure()));


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
