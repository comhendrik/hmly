import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class ChangeUserAttributes {
  final AuthRepository repository;

  ChangeUserAttributes({required this.repository});

  Future<Either<Failure, User>> execute(Map<String, dynamic> data, String userID) async {
    return await repository.changeUserAttributes(data,userID);
  }
}