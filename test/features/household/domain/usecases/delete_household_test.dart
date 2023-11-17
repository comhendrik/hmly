import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';
import 'package:household_organizer/features/household/domain/usecases/delete_household.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../test_data.dart';

class MockHouseholdRepository extends Mock implements HouseholdRepository {}

void main() {
  late MockHouseholdRepository repository;
  late DeleteHousehold usecase;

  setUpAll(() {
    repository = MockHouseholdRepository();
    usecase = DeleteHousehold(repository: repository);
  });

  test('should get valid object when call is successful', () async {
    when(() => repository.deleteHousehold("householdID")).thenAnswer((_) async =>  const Right( () ));

    final result = await usecase.execute("householdID");

    expect(result, equals(const Right( () )));
  });

  test('should get Failure of FailureType.server when when call is unsuccessful and throws Server Exception', () async {
    when(() => repository.deleteHousehold("householdID")).thenAnswer((_) async => Left(Failure(data: tFailureTypeServerResponseStructure, type: FailureType.server)));

    final result = await usecase.execute("householdID");

    expect(result, equals(Left(Failure(data: tFailureTypeServerResponseStructure, type: FailureType.server))));
  });

  test('should get Failure of FailureType.unknown when when call is unsuccessful and throws Unknown Exception', () async {
    when(() => repository.deleteHousehold("householdID")).thenAnswer((_) async => Left(Failure(data: tFailureTypeUnknownResponseStructure, type: FailureType.unknown)));

    final result = await usecase.execute("householdID");

    expect(result, equals(Left(Failure(data: tFailureTypeUnknownResponseStructure, type: FailureType.unknown))));
  });

}