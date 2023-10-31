import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class RequestVerification {
  final AuthRepository repository;

  RequestVerification({required this.repository});

  Future<Either<Failure, void>> execute(String email) async {
    return await repository.requestVerification(email);
  }
}