import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/core/entities/user.dart';
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

  const tUser = User(id: "id", username: "username123", householdId: "id", email: "test@example.com", name: "test");

  final tUsers = [tUser];

  final tHousehold = Household(id: 'id', title: 'title', users: tUsers, minWeeklyPoints: 123);

  test('should get valid object when call is successful', () async {
    when(() => repository.loadHousehold()).thenAnswer((_) async => Right(tHousehold));

    final result = await usecase.execute();

    verify(() => repository.loadHousehold());

    expect(result, equals( Right(tHousehold)));
  });

  test('should get ServerFailure when call is unsuccessful', () async {
    when(() => repository.loadHousehold()).thenAnswer((_) async => Left(ServerFailure()));

    final result = await usecase.execute();

    verify(() => repository.loadHousehold());

    expect(result, equals(Left(ServerFailure())));
  });
}