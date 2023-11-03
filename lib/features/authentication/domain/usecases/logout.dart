import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout({required this.repository});

  Future<Either<Failure, void>> execute() async {
    return repository.logout();
  }
}