import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class RequestNewPassword {
  final AuthRepository repository;

  RequestNewPassword({required this.repository});

  Future<void> execute(String userEmail) async {
    await repository.requestNewPassword(userEmail);
  }
}