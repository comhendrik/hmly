import 'package:dartz/dartz.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';
import 'package:hmly/features/authentication/presentation/widgets/change_user_attributes_widget.dart';

class ChangeUserAttributes {
  final AuthRepository repository;

  ChangeUserAttributes({required this.repository});

  Future<Either<Failure, User>> execute(String input, String? confirmationPassword, String? oldPassword, User user, UserChangeType type) async {
    return await repository.changeUserAttributes(input, confirmationPassword, oldPassword, user, type);
  }
}