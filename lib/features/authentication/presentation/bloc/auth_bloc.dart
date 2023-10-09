import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/usecases/add_auth_data_to_household.dart';
import 'package:household_organizer/features/authentication/domain/usecases/create_Household_And_Add_Auth_Data.dart';
import 'package:household_organizer/features/authentication/domain/usecases/create_auth_data.dart';
import 'package:household_organizer/features/authentication/domain/usecases/create_auth_data_on_server.dart';
import 'package:household_organizer/features/authentication/domain/usecases/delete_auth_data_from_household.dart';
import 'package:household_organizer/features/authentication/domain/usecases/load_auth_data.dart';
import 'package:household_organizer/features/authentication/domain/usecases/load_auth_data_with_o_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateAuthData createAuth;
  final LoadAuthData loadAuth;
  final CreateAuthDataOnServer createAuthDataOnServer;
  final AddAuthDataToHousehold addAuthDataToHousehold;
  final CreateHouseholdAndAddAuthData createHouseholdAndAddAuthData;
  final DeleteAuthDataFromHousehold deleteAuthDataFromHousehold;
  final LoadAuthDataWithOAuth loadAuthDataWithOAuth;
  AuthBloc({
    required this.createAuth,
    required this.loadAuth,
    required this.createAuthDataOnServer,
    required this.addAuthDataToHousehold,
    required this.createHouseholdAndAddAuthData,
    required this.deleteAuthDataFromHousehold,
    required this.loadAuthDataWithOAuth
  }) : super(AuthInitial()) {

    //TODO: Bug when creating new data on server and on device when username is already in use
    on<AuthEvent>((event, emit) async {
      emit(AuthInitial());
      if (event is CreateAuthEvent)  {
        emit(AuthLoading());
        await createAuth.execute(event.email, event.password);
        final resultEither = await loadAuth.execute();
        await resultEither.fold(
            (failure) async {
              if (failure.runtimeType == CacheFailure) {
                emit(const AuthError(errorMsg: 'Cache Failure'));
              } else {
                emit(const AuthError(errorMsg: 'Server Failure'));
              }
            },
            (auth) async {
              emit(AuthLoaded(authData: auth));
            }
        );
      } else if (event is LoadAuthEvent) {
        emit(AuthLoading());
        final resultEither = await loadAuth.execute();
        await resultEither.fold(
            (failure) async {
              emit(AuthCreate());
            },
            (auth) async {
              emit(AuthLoaded(authData: auth));
            }
        );
      } else if (event is CreateAuthDataOnServerEvent) {
        emit(AuthLoading());
        final resultEither = await createAuthDataOnServer.execute(event.email, event.password, event.passwordConfirm, event.username, event.name);
        await resultEither.fold(
                (failure) async {
                  //TODO: Maybe use dynamic error messages, because username that is already in use is not the only failure, for example email, idea: check error message from datasource for email and username and provide a suiting errormsg
              emit(const AuthError(errorMsg: 'Username or email is already in use'));
            },
                (auth) async {
              emit(AuthLoaded(authData: auth));
            }
        );
      } else if (event is AddAuthDataToHouseholdEvent) {
        emit(AuthLoading());
        final resultEither = await addAuthDataToHousehold.execute(event.user.id, event.householdId);
        await resultEither.fold(
                (failure) async {
                  if (failure.runtimeType == ServerFailure) {
                    emit(const AuthError(errorMsg: 'Server Failure'));
                  } else {
                    emit(AuthError(errorMsg: 'Household with ${event.householdId} not found'));
                  }
            },
                (_) async {
                  final newUser = User(id: event.user.id, username: event.user.username, householdId: event.householdId, email: event.user.email, name: event.user.name);
                  emit(AuthLoaded(authData: newUser));
            }
        );
      } else if (event is CreateHouseholdAndAddAuthDataEvent) {
        emit(AuthLoading());
        final resultEither = await createHouseholdAndAddAuthData.execute(event.user.id, event.householdTitle);
        await resultEither.fold(
                (failure) async {
              if (failure.runtimeType == ServerFailure) {
                emit(const AuthError(errorMsg: 'Server Failure'));
              } else {
                emit(AuthError(errorMsg: "Household with ${event.householdTitle} can't be created"));
              }
            },
                (householdId) async {
              final newUser = User(id: event.user.id, username: event.user.username, householdId: householdId, email: event.user.email, name: event.user.name);
              emit(AuthLoaded(authData: newUser));
            }
        );
      } else if (event is DeleteAuthDataFromHouseholdEvent) {
        emit(AuthLoading());
        final resultEither = await deleteAuthDataFromHousehold.execute(event.user);
        await resultEither.fold(
                (failure) async {
              emit(const AuthError(errorMsg: 'ServerFailure'));
            },
                (_) async {
              final newUser = User(id: event.user.id, username: event.user.username, householdId: "", email: event.user.email, name: event.user.name);
              emit(AuthLoaded(authData: newUser));
            }
        );
      } else if (event is LoadAuthDataWithOAuthEvent) {
        emit(AuthLoading());
        final resultEither = await loadAuthDataWithOAuth.execute();
        await resultEither.fold(
                (failure) async {
              emit(AuthError(errorMsg: "Server Failure"));
            },
                (auth) async {
              emit(AuthLoaded(authData: auth));
            }
        );
      }
    });
  }
}
