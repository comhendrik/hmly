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
  final int startCurrentPageIndex;
  const AuthLoaded({
    required this.authData,
    required this.startCurrentPageIndex
  });

  @override
  List<Object> get props => [];
}

class AuthCreate extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final Failure failure;
  const AuthError({
    required this.failure
  });

  @override
  List<Object> get props => [];
}