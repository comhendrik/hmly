import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household/domain/repositories/household_repository.dart';

class DeleteHousehold {
  final HouseholdRepository repository;

  DeleteHousehold({required this.repository});

  Future<Either<Failure, void>> execute(String householdID) async {
    return await repository.deleteHousehold(householdID);
  }
}