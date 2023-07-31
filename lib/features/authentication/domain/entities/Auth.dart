import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final String email;
  final String password;

  const Auth({
    required this.email,
    required this.password
  });

  @override
  List<Object> get props => [email, password];

}