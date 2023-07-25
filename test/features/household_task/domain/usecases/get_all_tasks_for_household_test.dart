import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/domain/repositories/househald_task_repository.dart';
import 'package:household_organizer/features/household_task/domain/usecases/get_all_tasks_for_household.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockHouseholdTaskRepository extends Mock implements HouseholdTaskRepository {}

void main() {
  late MockHouseholdTaskRepository mockRepository;
  late GetAllTasksForHousehold getAllTasksForHousehold;

  setUpAll(() {
    mockRepository = MockHouseholdTaskRepository();
    getAllTasksForHousehold = GetAllTasksForHousehold(mockRepository);
  });

  final tHouseholdTask = HouseholdTask(id: '0', title: 'Waschen', date: DateTime(2023, 1,11), isDone: false);
  final tHouseholdTask1 = HouseholdTask(id: '1', title: 'Waschen', isDone: false);
  final tHouseholdTaskList = [tHouseholdTask, tHouseholdTask1];

  test('should get Tasks from Repository if call is successful', () async {
    when(() => mockRepository.getAllTasksForHousehold()).thenAnswer((_) async => Right(tHouseholdTaskList));

    final result = await getAllTasksForHousehold.execute();

    expect(result, equals(Right(tHouseholdTaskList)));

    verify(() => mockRepository.getAllTasksForHousehold());

    verifyNoMoreInteractions(mockRepository);
  });
  
  test('should get Failure from Repository if call is unsuccessful', () async {
    when(() => mockRepository.getAllTasksForHousehold()).thenAnswer((_) async => Left(ServerFailure()));

    final result = await getAllTasksForHousehold.execute();

    expect(result, equals(Left(ServerFailure())));

    verify(() => mockRepository.getAllTasksForHousehold());

    verifyNoMoreInteractions(mockRepository);
  });
}

