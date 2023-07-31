import 'package:household_organizer/features/authentication/domain/entities/Auth.dart';

class AuthModel extends Auth {

  const AuthModel({
    required String email,
    required String password
  }) : super (
    email: email,
    password: password
  );


  factory AuthModel.fromData(String email, String password) {
    return AuthModel(email: email, password: password);
  }

}