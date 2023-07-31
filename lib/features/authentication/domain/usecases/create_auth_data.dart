import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';

class CreateAuthData {
  final AuthRepository repository;

  CreateAuthData({required this.repository});

  Future<void> execute(String email, String password) async {
    return await repository.createAuthData(email, password);
  }
}