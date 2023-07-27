import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/entities/user.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';
import 'package:household_organizer/features/household/domain/usecases/load_household.dart';
import 'package:mocktail/mocktail.dart';

class MockHouseholdRepository extends Mock implements HouseholdRepository {}

void main() {
  late MockHouseholdRepository repository;
  late LoadHousehold usecase;

  setUpAll(() {
    repository = MockHouseholdRepository();
    usecase = LoadHousehold(repository: repository);
  });

  const tHousehold = Household(id: 'id', title: 'title', users: [User(id: 'id', username: 'username', householdId: 'householdId', email: 'email', name: 'name')], minWeeklyPoints: 123);

  test('should get valid object when call is successful', () async {
    when(() => repository.loadHousehold()).thenAnswer((_) async => const Right(tHousehold));

    final result = await usecase.execute();

    verify(() => repository.loadHousehold());

    expect(result, equals(const Right(tHousehold)));
  });

  test('should get ServerFailure when call is unsuccessful', () async {
    when(() => repository.loadHousehold()).thenAnswer((_) async => Left(ServerFailure()));

    final result = await usecase.execute();

    verify(() => repository.loadHousehold());

    expect(result, equals(Left(ServerFailure())));
  });
}