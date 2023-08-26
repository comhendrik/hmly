part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoaded extends AuthState {
  final User authData;
  const AuthLoaded({required this.authData});

  @override
  List<Object> get props => [];
}

class AuthCreate extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String errorMsg;
  const AuthError({required this.errorMsg});

  @override
  List<Object> get props => [];
}