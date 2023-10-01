import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class CreateHouseholdAndAddAuthData {
  final AuthRepository repository;

  CreateHouseholdAndAddAuthData({required this.repository});

  Future<Either<Failure, String>> execute(String userId, String householdTitle) async {
    return await repository.createHouseholdAndAddAuthData(userId, householdTitle);
  }
}