import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/data/datasources/household_remote_data_source.dart';
import 'package:household_organizer/features/household/data/repositories/household_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../test_data.dart';

class MockHouseholdRemoteDataSource extends Mock implements HouseholdRemoteDataSource {}

void main() {

  late MockHouseholdRemoteDataSource remoteDataSource;
  late HouseholdRepositoryImpl repository;

  setUpAll(() {
    remoteDataSource = MockHouseholdRemoteDataSource();
    repository = HouseholdRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('loadHousehold', () {

    test('should return data, when call is successful', () async {


      when(() => remoteDataSource.loadHousehold("householdID")).thenAnswer((_) async => tHouseholdModel);

      final result = await repository.loadHousehold("householdID");

      expect(result, equals(Right(tHousehold)));

    });
    test('should return failure of type FailureType.server , when call is unsuccessful', () async {
      when(() => remoteDataSource.loadHousehold("householdID")).thenThrow(ServerException(response: tFailureTypeServerResponseStructure));

      final result = await repository.loadHousehold("householdID");

      expect(result, equals(Left(Failure(data: tFailureTypeServerResponseStructure, type: FailureType.server))));

    });

    test('should return failure of type FailureType.unknown , when call is unsuccessful', () async {
      when(() => remoteDataSource.loadHousehold("householdID")).thenThrow(UnknownException());

      final result = await repository.loadHousehold("householdID");

      expect(result, equals(Left(Failure(data: tFailureTypeUnknownResponseStructure, type: FailureType.unknown))));

    });
  });

  group('updateHouseholdTitle', () {

    test('should return data, when call is successful', () async {


      when(() => remoteDataSource.updateHouseholdTitle("householdID", "householdTitle")).thenAnswer((_) async => tHouseholdModel);

      final result = await repository.updateHouseholdTitle("householdID", "householdTitle");

      expect(result, equals(Right(tHousehold)));

    });
    test('should return failure of type FailureType.server , when call is unsuccessful', () async {
      when(() => remoteDataSource.updateHouseholdTitle("householdID", "householdTitle")).thenThrow(ServerException(response: tFailureTypeServerResponseStructure));

      final result = await repository.updateHouseholdTitle("householdID", "householdTitle");

      expect(result, equals(Left(Failure(data: tFailureTypeServerResponseStructure, type: FailureType.server))));

    });

    test('should return failure of type FailureType.unknown , when call is unsuccessful', () async {
      when(() => remoteDataSource.updateHouseholdTitle("householdID", "householdTitle")).thenThrow(UnknownException());

      final result = await repository.updateHouseholdTitle("householdID", "householdTitle");

      expect(result, equals(Left(Failure(data: tFailureTypeUnknownResponseStructure, type: FailureType.unknown))));

    });
  });

  group('deleteAuthDataFromHousehold', () {

    test('should return void, when call is successful', () async {


      when(() => remoteDataSource.deleteAuthDataFromHousehold("userID")).thenAnswer((_) async => ());

      final result = await repository.deleteAuthDataFromHousehold("userID");

      expect(result, equals(const Right( () )));

    });
    test('should return failure of type FailureType.server , when call is unsuccessful', () async {
      when(() => remoteDataSource.deleteAuthDataFromHousehold("userID")).thenThrow(ServerException(response: tFailureTypeServerResponseStructure));

      final result = await repository.deleteAuthDataFromHousehold("userID");

      expect(result, equals(Left(Failure(data: tFailureTypeServerResponseStructure, type: FailureType.server))));

    });

    test('should return failure of type FailureType.unknown , when call is unsuccessful', () async {
      when(() => remoteDataSource.deleteAuthDataFromHousehold("userID")).thenThrow(UnknownException());

      final result = await repository.deleteAuthDataFromHousehold("userID");

      expect(result, equals(Left(Failure(data: tFailureTypeUnknownResponseStructure, type: FailureType.unknown))));

    });
  });

  group('updateAdmin', () {

    test('should return data, when call is successful', () async {


      when(() => remoteDataSource.updateAdmin("householdID", "userID")).thenAnswer((_) async => tHouseholdModel);

      final result = await repository.updateAdmin("householdID", "userID");

      expect(result, equals(Right(tHousehold)));

    });
    test('should return failure of type FailureType.server , when call is unsuccessful', () async {
      when(() => remoteDataSource.updateAdmin("householdID", "userID")).thenThrow(ServerException(response: tFailureTypeServerResponseStructure));

      final result = await repository.updateAdmin("householdID", "userID");

      expect(result, equals(Left(Failure(data: tFailureTypeServerResponseStructure, type: FailureType.server))));

    });

    test('should return failure of type FailureType.unknown , when call is unsuccessful', () async {
      when(() => remoteDataSource.updateAdmin("householdID", "userID")).thenThrow(UnknownException());

      final result = await repository.updateAdmin("householdID", "userID");

      expect(result, equals(Left(Failure(data: tFailureTypeUnknownResponseStructure, type: FailureType.unknown))));

    });
  });

  group('loadHousehold', () {

    test('should return void, when call is successful', () async {


      when(() => remoteDataSource.deleteHousehold("householdID")).thenAnswer((_) async => ());

      final result = await repository.deleteHousehold("householdID");

      expect(result, equals(const Right( () )));

    });
    test('should return failure of type FailureType.server , when call is unsuccessful', () async {
      when(() => remoteDataSource.deleteHousehold("householdID")).thenThrow(ServerException(response: tFailureTypeServerResponseStructure));

      final result = await repository.deleteHousehold("householdID");

      expect(result, equals(Left(Failure(data: tFailureTypeServerResponseStructure, type: FailureType.server))));

    });

    test('should return failure of type FailureType.unknown , when call is unsuccessful', () async {
      when(() => remoteDataSource.deleteHousehold("householdID")).thenThrow(UnknownException());

      final result = await repository.deleteHousehold("householdID");

      expect(result, equals(Left(Failure(data: tFailureTypeUnknownResponseStructure, type: FailureType.unknown))));

    });
  });


}