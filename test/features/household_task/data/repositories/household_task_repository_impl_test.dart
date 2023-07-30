import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:mocktail/mocktail.dart';
import 'package:household_organizer/features/household_task/data/repositories/household_task_repository_impl.dart';

class MockHouseholdTaskRemoteDataSource extends Mock implements HouseholdTaskRemoteDataSource {}

void main() {

  late MockHouseholdTaskRemoteDataSource remoteDataSource;
  late HouseholdTaskRepositoryImpl repository;

  setUpAll(() {
    remoteDataSource = MockHouseholdTaskRemoteDataSource();
    repository = HouseholdTaskRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('getAllTasksForHousehold', () {
    final tHouseholdTaskModel = HouseholdTaskModel(id: "id", title: "title", date: DateTime(2023, 1,11), isDone: false);
    final List<HouseholdTaskModel> tHouseholdTaskModelList = [tHouseholdTaskModel];
    final List<HouseholdTask> tHouseholdTaskList = tHouseholdTaskModelList;
    test('should return data, when call is successful', () async {
      when(() => remoteDataSource.getAllTaskForHousehold()).thenAnswer((_) async => tHouseholdTaskModelList);

      final result = await repository.getAllTasksForHousehold();

      expect(result, equals(Right(tHouseholdTaskList)));

    });
    test('should return failure, when call is unsuccessful', () async {
      when(() => remoteDataSource.getAllTaskForHousehold()).thenThrow(ServerException());

      final result = await repository.getAllTasksForHousehold();

      expect(result, equals(Left(ServerFailure())));

    });
  });

  group('createHouseholdTask', () {
    final tTitle = 'Waschen';
    final tPointsWorth = 2;
    final tHouseholdTask = HouseholdTask(id: '0', title: tTitle, date: DateTime(2023, 1,11), isDone: false);

    test('should return data, when call is successful', () async {
      when(() => remoteDataSource.createHouseholdTask(tTitle, tPointsWorth)).thenAnswer((_) async => tHouseholdTask);

      final result = await repository.createHouseholdTask(tTitle, tPointsWorth);

      expect(result, equals(Right(tHouseholdTask)));

    });
    test('should return failure, when call is unsuccessful', () async {
      when(() => remoteDataSource.createHouseholdTask(tTitle, tPointsWorth)).thenThrow(ServerException());

      final result = await repository.createHouseholdTask(tTitle, tPointsWorth);

      expect(result, equals(Left(ServerFailure())));

    });
  });
}