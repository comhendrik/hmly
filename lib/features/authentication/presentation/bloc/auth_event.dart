part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AddAuthDataToHouseholdEvent extends AuthEvent {
  final User user;
  final String householdID;
  final BuildContext context;
  final String msg;

  AddAuthDataToHouseholdEvent({
    required this.user,
    required this.householdID,
    required this.context
  }) : msg = AppLocalizations.of(context)!.addAuthDataToHouseholdEvent;
}

class CreateHouseholdAndAddAuthDataEvent extends AuthEvent {
  final User user;
  final String householdTitle;
  final BuildContext context;
  final String msg;

  CreateHouseholdAndAddAuthDataEvent({
    required this.user,
    required this.householdTitle,
    required this.context
  }) : msg = AppLocalizations.of(context)!.createHouseholdAndAddAuthDataEvent;
}

class LeaveHouseholdEvent extends AuthEvent {
  final User user;
  final BuildContext context;
  final String msg;

  LeaveHouseholdEvent({
    required this.user,
    required this.context
  }) : msg = AppLocalizations.of(context)!.leaveHouseholdEvent;
}

class LoginAuthEvent extends AuthEvent {

  final String email;
  final String password;
  final BuildContext context;
  final String msg;

  LoginAuthEvent({
    required this.email,
    required this.password,
    required this.context
  }) : msg = AppLocalizations.of(context)!.loginAuthEvent;

}

class LoadAuthEvent extends AuthEvent {
  final BuildContext context;
  final String msg;

  LoadAuthEvent({
    required this.context
  }) : msg = AppLocalizations.of(context)!.loadAuthEvent;
}

class SignUpAuthEvent extends AuthEvent {
  final String email;
  final String password;
  final String passwordConfirm;
  final String username;
  final String name;
  final BuildContext context;
  final String msg;

  SignUpAuthEvent({
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.username,
    required this.name,
    required this.context
  }) : msg = AppLocalizations.of(context)!.signUpAuthEvent;
}


//TODO: Delete oauth
class LoadAuthDataWithOAuthEvent extends AuthEvent {
  final String msg = "Signin in withoauth";

  const LoadAuthDataWithOAuthEvent();

}

class LogoutEvent extends AuthEvent {
  final BuildContext context;
  final String msg;

  LogoutEvent({
    required this.context
  }) : msg = AppLocalizations.of(context)!.logoutEvent;
}

class ChangeUserAttributesEvent extends AuthEvent {
  final String input;
  final String? confirmationPassword;
  final String? oldPassword;
  final User user;
  final UserChangeType type;
  final BuildContext context;
  final String msg;

  ChangeUserAttributesEvent({
    required this.input,
    required this.confirmationPassword,
    required this.oldPassword,
    required this.user,
    required this.type,
    required this.context
  }) : msg = AppLocalizations.of(context)!.changeUserAttributesEvent;
}

class RequestNewPasswordEvent extends AuthEvent {
  final String userEmail;
  final BuildContext context;
  final String msg;

  RequestNewPasswordEvent({
    required this.userEmail,
    required this.context
  }): msg = AppLocalizations.of(context)!.requestNewPasswordEvent;
}

class RequestEmailChangeEvent extends AuthEvent {
  final String newEmail;
  final User user;
  final BuildContext context;
  final String msg;

  RequestEmailChangeEvent({
    required this.newEmail,
    required this.user,
    required this.context
  }) : msg = AppLocalizations.of(context)!.requestEmailChangeEvent;
}

class RequestVerificationEvent extends AuthEvent {
  final User user;
  final BuildContext context;
  final String msg;

  RequestVerificationEvent({
    required this.user,
    required this.context
  }) : msg = AppLocalizations.of(context)!.requestVerificationEvent;
}

class DeleteUserEvent extends AuthEvent {
  final User user;
  final BuildContext context;
  final String msg;

  DeleteUserEvent({
    required this.user,
    required this.context
  }) : msg = AppLocalizations.of(context)!.deleteUserEvent;
}

