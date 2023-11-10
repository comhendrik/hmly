import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';
import 'package:household_organizer/features/household/domain/usecases/update_household_title.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../test_data.dart';

class MockHouseholdRepository extends Mock implements HouseholdRepository {}

void main() {
  late MockHouseholdRepository repository;
  late UpdateHouseholdTitle usecase;

  setUpAll(() {
    repository = MockHouseholdRepository();
    usecase = UpdateHouseholdTitle(repository: repository);
  });

  const tUpdatedHousehold = Household(
      id: "id",
      title: "title",
      users: [
        User(
            id: "id",
            username: "username",
            householdID: "id",
            email: "email",
            name: "name",
            verified: true
        )
      ],
      admin: User(
          id: "id",
          username: "username",
          householdID: "id",
          email: "email",
          name: "name",
          verified: true
      )
  );

  test('should get valid object when call is successful', () async {
    when(() => repository.updateHouseholdTitle("householdID", "title")).thenAnswer((_) async => const Right(tUpdatedHousehold));

    final result = await usecase.execute("householdID", "title");

    expect(result, equals(const Right(tUpdatedHousehold)));
  });

  test('should get Failure of FailureType.server when when call is unsuccessful and throws Server Exception', () async {
    when(() => repository.updateHouseholdTitle("householdID", "title")).thenAnswer((_) async => Left(Failure(data: tFailureTypeServerResponseStructure, type: FailureType.server)));

    final result = await usecase.execute("householdID", "title");

    expect(result, equals(Left(Failure(data: tFailureTypeServerResponseStructure, type: FailureType.server))));
  });

  test('should get Failure of FailureType.unknown when when call is unsuccessful and throws Unknown Exception', () async {
    when(() => repository.updateHouseholdTitle("householdID", "title")).thenAnswer((_) async => Left(Failure(data: tFailureTypeUnknownResponseStructure, type: FailureType.unknown)));

    final result = await usecase.execute("householdID", "title");

    expect(result, equals(Left(Failure(data: tFailureTypeUnknownResponseStructure, type: FailureType.unknown))));
  });

}