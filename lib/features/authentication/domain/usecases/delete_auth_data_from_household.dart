import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class DeleteAuthDataFromHousehold {
  final AuthRepository repository;

  DeleteAuthDataFromHousehold({required this.repository});

  Future<Either<Failure, void>> execute(User user) async {
    return await repository.deleteAuthDataFromHousehold(user);
  }
}