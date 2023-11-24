import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:hmly/features/household/domain/repositories/household_repository.dart';

class AddIDToAllowedUsers {
  final HouseholdRepository repository;

  AddIDToAllowedUsers({required this.repository});

  Future<Either<Failure, Household>> execute(String userID, Household household) async {
    return await repository.addIdToAllowedUsers(userID, household);
  }
}