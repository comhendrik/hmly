import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';

class CreateHouseholdAndAddAuthData {
  final AuthRepository repository;

  CreateHouseholdAndAddAuthData({required this.repository});

  Future<Either<Failure, String>> execute(String userID) async {
    return await repository.createHouseholdAndAddAuthData(userID);
  }
}