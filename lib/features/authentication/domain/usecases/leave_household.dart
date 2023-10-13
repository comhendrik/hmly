import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class LeaveHousehold {
  final AuthRepository repository;

  LeaveHousehold({required this.repository});

  Future<Either<Failure, void>> execute(User user) async {
    return await repository.leaveHousehold(user);
  }
}