import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/change_user_attributes_widget.dart';

class ChangeUserAttributes {
  final AuthRepository repository;

  ChangeUserAttributes({required this.repository});

  Future<Either<Failure, User>> execute(String input, String? confirmationPassword, String? oldPassword, User user, UserChangeType type) async {
    return await repository.changeUserAttributes(input, confirmationPassword, oldPassword, user, type);
  }
}