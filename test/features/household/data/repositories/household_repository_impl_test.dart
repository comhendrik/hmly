import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/data/datasources/household_remote_data_source.dart';
import 'package:household_organizer/features/household/data/models/household_model.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:household_organizer/features/household/data/repositories/household_repository_impl.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:mocktail/mocktail.dart';

class MockHouseholdRemoteDataSource extends Mock implements HouseholdRemoteDataSource {}

void main() {

  late MockHouseholdRemoteDataSource remoteDataSource;
  late HouseholdRepositoryImpl repository;

  setUpAll(() {
    remoteDataSource = MockHouseholdRemoteDataSource();
    repository = HouseholdRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('getAllTasksForHousehold', () {

    const tUser = UserModel(id: "id", username: "username123", householdId: "id", email: "test@example.com", name: "test");

    final List<User> tUsers = [tUser];


    final tHouseholdModel = HouseholdModel(id: 'id', title: 'title', users: tUsers, minWeeklyPoints: 123);
    final Household tHousehold = tHouseholdModel;
    test('should return data, when call is successful', () async {


      when(() => remoteDataSource.loadHousehold()).thenAnswer((_) async => tHouseholdModel);

      final result = await repository.loadHousehold();

      expect(result, equals(Right(tHousehold)));

    });
    test('should return failure, when call is unsuccessful', () async {
      when(() => remoteDataSource.loadHousehold()).thenThrow(ServerException());

      final result = await repository.loadHousehold();

      expect(result, equals(Left(ServerFailure())));

    });
  });
}