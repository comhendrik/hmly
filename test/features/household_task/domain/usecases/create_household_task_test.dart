import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/domain/repositories/household_task_repository.dart';
import 'package:household_organizer/features/household_task/domain/usecases/create_household_task.dart';
import 'package:household_organizer/features/household_task/domain/usecases/get_all_tasks_for_household.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockHouseholdTaskRepository extends Mock implements HouseholdTaskRepository {}

void main() {
  late MockHouseholdTaskRepository mockRepository;
  late CreateHouseholdTask createHouseholdTask;

  setUpAll(() {
    mockRepository = MockHouseholdTaskRepository();
    createHouseholdTask = CreateHouseholdTask(repository: mockRepository);
  });




  test('should get Tasks from Repository if call is successful', () async {
    final tTitle = 'Waschen';
    final tPointsWorth = 2;
    final tHouseholdTask = HouseholdTask(id: '0', title: tTitle, date: DateTime(2023, 1,11), isDone: false);


    when(() => mockRepository.createHouseholdTask(tTitle, tPointsWorth)).thenAnswer((_) async => Right(tHouseholdTask));

    final result = await createHouseholdTask.execute(tTitle, tPointsWorth);

    expect(result, equals(Right(tHouseholdTask)));

    verify(() => mockRepository.createHouseholdTask(tTitle, tPointsWorth));

    verifyNoMoreInteractions(mockRepository);
  });

  test('should get Failure from Repository if call is unsuccessful', () async {
    final tTitle = 'Waschen';
    final tPointsWorth = 2;
    when(() => mockRepository.createHouseholdTask(tTitle, tPointsWorth)).thenAnswer((_) async => Left(ServerFailure()));

    final result = await createHouseholdTask.execute(tTitle, tPointsWorth);

    expect(result, equals(Left(ServerFailure())));

    verify(() => mockRepository.createHouseholdTask(tTitle, tPointsWorth));

    verifyNoMoreInteractions(mockRepository);
  });
}