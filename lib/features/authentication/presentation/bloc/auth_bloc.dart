import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/domain/usecases/create_auth_data.dart';
import 'package:household_organizer/features/authentication/domain/usecases/load_auth_data.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateAuthData createAuth;
  final LoadAuthData loadAuth;
  AuthBloc({required this.createAuth, required this.loadAuth}) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      emit(AuthInitial());
      if (event is CreateAuthEvent)  {
        emit(AuthLoading());
        await createAuth.execute(event.email, event.password);
        final resultEither = await loadAuth.execute();
        await resultEither.fold(
                (failure) async {
              emit(const AuthError(errorMsg: 'Server Failure'));
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
      }
    });
  }
}
