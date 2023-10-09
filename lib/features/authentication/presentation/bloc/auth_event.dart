part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AddAuthDataToHouseholdEvent extends AuthEvent {
  final User user;
  final String householdId;

  const AddAuthDataToHouseholdEvent({
    required this.user,
    required this.householdId
  });
}

class CreateHouseholdAndAddAuthDataEvent extends AuthEvent {
  final User user;
  final String householdTitle;

  const CreateHouseholdAndAddAuthDataEvent({
    required this.user,
    required this.householdTitle
  });
}

class DeleteAuthDataFromHouseholdEvent extends AuthEvent {
  final User user;

  const DeleteAuthDataFromHouseholdEvent({
    required this.user
  });
}

class CreateAuthEvent extends AuthEvent {

  final String email;
  final String password;

  const CreateAuthEvent({
    required this.email,
    required this.password
  });

}

class LoadAuthEvent extends AuthEvent {}

class CreateAuthDataOnServerEvent extends AuthEvent {
  final String email;
  final String password;
  final String passwordConfirm;
  final String username;
  final String name;

  const CreateAuthDataOnServerEvent({
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.username,
    required this.name,
  });
}

class LoadAuthDataWithOAuthEvent extends AuthEvent {

  const LoadAuthDataWithOAuthEvent();

}

