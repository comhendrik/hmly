import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household/domain/repositories/household_repository.dart';

class DeleteAuthDataFromHousehold {
  final HouseholdRepository repository;

  DeleteAuthDataFromHousehold({required this.repository});

  Future<Either<Failure, void>> execute(String userID) async {
    return await repository.deleteAuthDataFromHousehold(userID);
  }
}