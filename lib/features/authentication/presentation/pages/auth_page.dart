import 'package:household_organizer/core/widgets/bloc_error_widget.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../injection_container.dart';

class AuthPage extends StatelessWidget {

  const AuthPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<AuthBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            BlocProvider.of<AuthBloc>(context)
                .add(LoadAuthEvent());
            return const Text("Data is loading...");
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthLoaded) {
            return state.authData.householdID == "" ? AddAuthDataToHouseholdView(user: state.authData) : AuthenticatedView(mainUser: state.authData);
          } else if (state is AuthError) {
            return BlocErrorWidget(errorMsg: state.errorMsg, reloadAction: () {
              BlocProvider.of<AuthBloc>(context)
                  .add(LoadAuthEvent());
            });
          } else if (state is AuthCreate){
            return const AuthenticationWidget();
          } else {
            return const Text("...");
          }
        },
      ),
    );
  }
}




