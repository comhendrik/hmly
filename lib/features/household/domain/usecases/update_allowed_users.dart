import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:hmly/features/household/domain/repositories/household_repository.dart';

class UpdateAllowedUsers {
  final HouseholdRepository repository;

  UpdateAllowedUsers({required this.repository});

  Future<Either<Failure, Household>> execute(String userID, Household household, bool delete) async {
    return await repository.updateAllowedUsers(userID, household, delete);
  }
}