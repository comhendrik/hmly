part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AddAuthDataToHouseholdEvent extends AuthEvent {
  final User user;
  final String householdID;
  final String msg = "User is added to Household";

  const AddAuthDataToHouseholdEvent({
    required this.user,
    required this.householdID
  });
}

class CreateHouseholdAndAddAuthDataEvent extends AuthEvent {
  final User user;
  final String householdTitle;
  final String msg = "Household is Created";

  const CreateHouseholdAndAddAuthDataEvent({
    required this.user,
    required this.householdTitle
  });
}

class LeaveHouseholdEvent extends AuthEvent {

  final User user;
  final String msg = "User leaves Household.";

  const LeaveHouseholdEvent({
    required this.user
  });
}

class LoginAuthEvent extends AuthEvent {

  final String email;
  final String password;
  final String msg = "User is logged in";

  const LoginAuthEvent({
    required this.email,
    required this.password
  });

}

class LoadAuthEvent extends AuthEvent {
  final String msg = "User is logged in";
}

class SignUpAuthEvent extends AuthEvent {
  final String email;
  final String password;
  final String passwordConfirm;
  final String username;
  final String name;
  final String msg = "User is signed up";

  const SignUpAuthEvent({
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.username,
    required this.name,
  });
}



class LoadAuthDataWithOAuthEvent extends AuthEvent {
  final String msg = "Signin in withoauth";

  const LoadAuthDataWithOAuthEvent();

}

class LogoutEvent extends AuthEvent {

  final String msg = "User is logged out";

  const LogoutEvent();

}

class ChangeUserAttributesEvent extends AuthEvent {
  //TODO: Neuer usecase und damit event, für das anfragen einer email änderung
  final String input;
  final String? token;
  final String? confirmationPassword;
  final String? oldPassword;
  final User user;
  final UserChangeType type;
  final String msg = "Attribute of user is changed";

  const ChangeUserAttributesEvent({
    required this.input,
    required this.token,
    required this.confirmationPassword,
    required this.oldPassword,
    required this.user,
    required this.type,
  });
}

class RequestNewPasswordEvent extends AuthEvent {
  final String userEmail;
  final String msg = "Password is going to be requested";

  const RequestNewPasswordEvent({
    required this.userEmail
  });
}

