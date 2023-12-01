import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/authentication/domain/usecases/add_auth_data_to_household.dart';
import 'package:hmly/features/authentication/domain/usecases/create_household_and_add_auth_data.dart';
import 'package:hmly/features/authentication/domain/usecases/delete_user.dart';
import 'package:hmly/features/authentication/domain/usecases/refresh_auth_data.dart';
import 'package:hmly/features/authentication/domain/usecases/request_verification.dart';
import 'package:hmly/features/authentication/domain/usecases/sign_up.dart';
import 'package:hmly/features/authentication/domain/usecases/leave_household.dart';
import 'package:hmly/features/authentication/domain/usecases/login.dart';
import 'package:hmly/features/authentication/domain/usecases/logout.dart';
import 'package:hmly/features/authentication/domain/usecases/change_user_attributes.dart';
import 'package:hmly/features/authentication/domain/usecases/request_new_password.dart';
import 'package:hmly/features/authentication/domain/usecases/request_email_change.dart';
import 'package:hmly/features/authentication/presentation/widgets/change_user_attributes_widget.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final SignUp createAuthDataOnServer;
  final AddAuthDataToHousehold addAuthDataToHousehold;
  final CreateHouseholdAndAddAuthData createHouseholdAndAddAuthData;
  final LeaveHousehold leaveHousehold;
  final Logout logout;
  final ChangeUserAttributes changeUserAttributes;
  final RequestNewPassword requestNewPassword;
  final RequestEmailChange requestEmailChange;
  final RequestVerification requestVerification;
  final RefreshAuthData refreshAuthData;
  final DeleteUser deleteUser;
  final AsyncAuthStore authStore;

  AuthBloc({

    required this.login,
    required this.createAuthDataOnServer,
    required this.addAuthDataToHousehold,
    required this.createHouseholdAndAddAuthData,
    required this.leaveHousehold,
    required this.logout,
    required this.changeUserAttributes,
    required this.requestNewPassword,
    required this.requestEmailChange,
    required this.requestVerification,
    required this.refreshAuthData,
    required this.deleteUser,
    required this.authStore

  }) : super(AuthInitial()) {

    on<AuthEvent>((event, emit) async {
      emit(AuthInitial());
      if (event is LoginAuthEvent)  {
        emit(AuthLoading(msg: event.msg));
        final resultEither = await login.execute(event.email, event.password);
        await resultEither.fold(
            (failure) async {
              emit(AuthError(failure: failure));
            },
            (auth) async {
              emit(AuthLoaded(authData: auth,  startCurrentPageIndex: 0));
            }
        );
      } else if (event is LoadAuthEvent) {
        /*
        bool connection = await InternetConnectionChecker().hasConnection;
        if (!connection) {
          emit(AuthNoConnection());
          return;
        }
         */
        emit(AuthLoading(msg: event.msg));

        if (authStore.model != null) {
          final resultEither = await refreshAuthData.execute();
          await resultEither.fold(
                  (failure) async {
                emit(AuthError(failure: failure));
              },
                  (auth) async {
                    RecordModel user = authStore.model;
                    emit(AuthLoaded(authData: User(id: user.id,username: user.data["username"],householdID: user.data["household"],email: user.data["email"], name: user.data["name"], verified: user.data["verified"]), startCurrentPageIndex: 2));
              }
          );
        } else {
          emit(AuthCreate());
        }

      } else if (event is SignUpAuthEvent) {
        emit(AuthLoading(msg: event.msg));
        final resultEither = await createAuthDataOnServer.execute(event.email, event.password, event.passwordConfirm, event.username, event.name);
        await resultEither.fold(
                (failure) async {
                  emit(AuthError(failure: failure));
            },
                (auth) async {
              emit(AuthLoaded(authData: auth,  startCurrentPageIndex: 0));
            }
        );
      } else if (event is AddAuthDataToHouseholdEvent) {
        emit(AuthLoading(msg: event.msg));
        final resultEither = await addAuthDataToHousehold.execute(event.user.id, event.householdID);
        await resultEither.fold(
                (failure) async {
                  emit(AuthError(failure: failure));
            },
                (_) async {
                  final newUser = User(id: event.user.id, username: event.user.username, householdID: event.householdID, email: event.user.email, name: event.user.name, verified: event.user.verified);
                  emit(AuthLoaded(authData: newUser,  startCurrentPageIndex: 0));
            }
        );
      } else if (event is CreateHouseholdAndAddAuthDataEvent) {
        emit(AuthLoading(msg: event.msg));
        final resultEither = await createHouseholdAndAddAuthData.execute(event.user.id, event.householdTitle);
        await resultEither.fold(
                (failure) async {
                  AuthError(failure: failure);
            },
                (householdID) async {
              final newUser = User(id: event.user.id, username: event.user.username, householdID: householdID, email: event.user.email, name: event.user.name, verified: event.user.verified);
              emit(AuthLoaded(authData: newUser, startCurrentPageIndex: 0));
            }
        );
      } else if (event is LeaveHouseholdEvent) {
        emit(AuthLoading(msg: event.msg));
        final resultEither = await leaveHousehold.execute(event.user);
        await resultEither.fold(
                (failure) async {
                  emit(AuthError(failure: failure));
            },
                (_) async {
              final newUser = User(id: event.user.id, username: event.user.username, householdID: "", email: event.user.email, name: event.user.name, verified: event.user.verified);
              emit(AuthLoaded(authData: newUser, startCurrentPageIndex: 0));
            }
        );

      } else if (event is LogoutEvent) {
        emit(AuthLoading(msg: event.msg));
        final resultEither = await logout.execute();
        await resultEither.fold(
                (failure) async {
              emit(AuthError(failure: failure));
            },
                (_) async {
              emit(AuthCreate());
            }
        );
        emit(AuthCreate());

      } else if (event is ChangeUserAttributesEvent) {
        emit(AuthLoading(msg: event.msg));
        final resultEither = await changeUserAttributes.execute(event.input, event.confirmationPassword, event.oldPassword, event.user, event.type);
        await resultEither.fold(
                (failure) async {
              emit(AuthError(failure: failure));
            },
                (auth) async {
                  if (event.type == UserChangeType.email) {
                    logout.execute();
                    emit(AuthCreate());
                    return;
                  }
              emit(AuthLoaded(authData: auth, startCurrentPageIndex: 2));
            }
        );
      } else if (event is RequestNewPasswordEvent) {
        emit(AuthLoading(msg: event.msg));
        final resultEither = await requestNewPassword.execute(event.userEmail);
        await resultEither.fold(
                (failure) async {
              emit(AuthError(failure: failure));
            },
                (_) async {
                  emit(AuthCreate());
            }
        );
      } else if (event is RequestEmailChangeEvent) {
        emit(AuthLoading(msg: event.msg));
        final resultEither = await requestEmailChange.execute(event.newEmail, event.user);
        await resultEither.fold(
                (failure) async {
              emit(AuthError(failure: failure));
            },
                (_) async {
                  logout.execute();
                  emit(AuthCreate());
            }
        );
      } else if (event is RequestVerificationEvent) {
        emit(AuthLoading(msg: event.msg));
        final resultEither = await requestVerification.execute(event.user.email);
        await resultEither.fold(
          (failure) async {
            emit(AuthError(failure: failure));
          },
          (_) async {
            emit(AuthLoaded(authData: event.user, startCurrentPageIndex: 0));
          }
        );
      } else if (event is DeleteUserEvent) {
        emit(AuthLoading(msg: event.msg));
        final logoutResultEither = await logout.execute();
        await logoutResultEither.fold(
          (failure) async {

            emit(AuthError(failure: failure));
          },
          (success) async {
            final resultEither = await deleteUser.execute(event.user);
            await resultEither.fold(
                    (failure) async {
                  emit(AuthError(failure: failure));
                },
                    (_) async {
                  emit(AuthCreate());
                }
            );
          }
        );

      }
    });
  }
}
