import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout({required this.repository});

  void execute() async {
    repository.logout();
  }
}