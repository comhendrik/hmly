import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';

class RequestNewPassword {
  final AuthRepository repository;

  RequestNewPassword({required this.repository});

  Future<Either<Failure, void>> execute(String userEmail) async {
    return await repository.requestNewPassword(userEmail);
  }
}