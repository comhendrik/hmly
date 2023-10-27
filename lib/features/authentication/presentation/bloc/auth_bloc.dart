import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/authentication/domain/usecases/add_auth_data_to_household.dart';
import 'package:household_organizer/features/authentication/domain/usecases/create_Household_And_Add_Auth_Data.dart';
import 'package:household_organizer/features/authentication/domain/usecases/sign_up.dart';
import 'package:household_organizer/features/authentication/domain/usecases/leave_household.dart';
import 'package:household_organizer/features/authentication/domain/usecases/login.dart';
import 'package:household_organizer/features/authentication/domain/usecases/load_auth_data_with_o_auth.dart';
import 'package:household_organizer/features/authentication/domain/usecases/logout.dart';
import 'package:household_organizer/features/authentication/domain/usecases/change_user_attributes.dart';
import 'package:household_organizer/features/authentication/domain/usecases/request_new_password.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/change_user_attributes_widget.dart';
import 'package:pocketbase/pocketbase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final SignUp createAuthDataOnServer;
  final AddAuthDataToHousehold addAuthDataToHousehold;
  final CreateHouseholdAndAddAuthData createHouseholdAndAddAuthData;
  final LeaveHousehold leaveHousehold;
  final LoadAuthDataWithOAuth loadAuthDataWithOAuth;
  final Logout logout;
  final ChangeUserAttributes changeUserAttributes;
  final RequestNewPassword requestNewPassword;
  final AsyncAuthStore authStore;
  AuthBloc({
    required this.login,
    required this.createAuthDataOnServer,
    required this.addAuthDataToHousehold,
    required this.createHouseholdAndAddAuthData,
    required this.leaveHousehold,
    required this.loadAuthDataWithOAuth,
    required this.logout,
    required this.changeUserAttributes,
    required this.requestNewPassword,
    required this.authStore
  }) : super(AuthInitial()) {

    //TODO: Bug when creating new data on server and on device when username is already in use
    on<AuthEvent>((event, emit) async {
      emit(AuthInitial());
      if (event is LoginAuthEvent)  {
        emit(AuthLoading());
        final resultEither = await login.execute(event.email, event.password);
        await resultEither.fold(
            (failure) async {
              const AuthError(errorMsg: 'Server Failure');
            },
            (auth) async {
              emit(AuthLoaded(authData: auth,  startCurrentPageIndex: 0));
            }
        );
      } else if (event is LoadAuthEvent) {
        emit(AuthLoading());
        if (authStore.model != null) {
          RecordModel user = authStore.model;
          emit(AuthLoaded(authData: User(id: user.id,username: user.data["username"],householdID: user.data["household"],email: user.data["email"], name: user.data["name"]), startCurrentPageIndex: 0));
        } else {
          emit(AuthCreate());
        }

      } else if (event is SignUpAuthEvent) {
        emit(AuthLoading());
        final resultEither = await createAuthDataOnServer.execute(event.email, event.password, event.passwordConfirm, event.username, event.name);
        await resultEither.fold(
                (failure) async {
                  //TODO: Maybe use dynamic error messages, because username that is already in use is not the only failure, for example email, idea: check error message from datasource for email and username and provide a suiting errormsg
              emit(const AuthError(errorMsg: 'Username or email is already in use'));
            },
                (auth) async {
              emit(AuthLoaded(authData: auth,  startCurrentPageIndex: 0));
            }
        );
      } else if (event is AddAuthDataToHouseholdEvent) {
        emit(AuthLoading());
        final resultEither = await addAuthDataToHousehold.execute(event.user.id, event.householdID);
        await resultEither.fold(
                (failure) async {
                  if (failure.runtimeType == ServerFailure) {
                    emit(const AuthError(errorMsg: 'Server Failure'));
                  } else {
                    emit(AuthError(errorMsg: 'Household with ${event.householdID} not found'));
                  }
            },
                (_) async {
                  final newUser = User(id: event.user.id, username: event.user.username, householdID: event.householdID, email: event.user.email, name: event.user.name);
                  emit(AuthLoaded(authData: newUser,  startCurrentPageIndex: 0));
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
                (householdID) async {
              final newUser = User(id: event.user.id, username: event.user.username, householdID: householdID, email: event.user.email, name: event.user.name);
              emit(AuthLoaded(authData: newUser, startCurrentPageIndex: 0));
            }
        );
      } else if (event is LeaveHouseholdEvent) {
        emit(AuthLoading());
        final resultEither = await leaveHousehold.execute(event.user);
        await resultEither.fold(
                (failure) async {
              emit(const AuthError(errorMsg: 'ServerFailure'));
            },
                (_) async {
              final newUser = User(id: event.user.id, username: event.user.username, householdID: "", email: event.user.email, name: event.user.name);
              emit(AuthLoaded(authData: newUser, startCurrentPageIndex: 0));
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
              emit(AuthLoaded(authData: auth, startCurrentPageIndex: 0));
            }
        );
      } else if (event is LogoutEvent) {
        emit(AuthLoading());
        logout.execute();
        emit(AuthCreate());
      } else if (event is ChangeUserAttributesEvent) {
        if (event.type != UserChangeType.email) {
          emit(AuthLoading());
          final resultEither = await changeUserAttributes.execute(event.input, event.token, event.confirmationPassword, event.oldPassword, event.userID, event.type);
          await resultEither.fold(
                  (failure) async {
                emit(const AuthError(errorMsg: "Server Failure"));
              },
                  (auth) async {
                emit(AuthLoaded(authData: auth, startCurrentPageIndex: 2));
              }
          );
        } else {
          final resultEither = await changeUserAttributes.execute(event.input, event.token, event.confirmationPassword, event.oldPassword, event.userID, event.type);
          await resultEither.fold(
              (failure) async {
                emit(const AuthError(errorMsg: "Server Failure"));
              },
              (auth) async {
                emit(AuthLoaded(authData: auth, startCurrentPageIndex: 2));
              }
          );
        }
      } else if (event is RequestNewPasswordEvent) {
        await requestNewPassword.execute(event.userEmail);
      }
    });
  }
}
