import 'package:household_organizer/core/widgets/bloc_error_widget.dart';
import 'package:household_organizer/core/widgets/custom_process_indicator_widget.dart';
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
            return const Text("Starting to load data...");
          } else if (state is AuthLoading) {
            return Center(
              child: CustomProcessIndicator(reloadAction: () {
                BlocProvider.of<AuthBloc>(context)
                    .add(LoadAuthEvent());
            }),
            );
          } else if (state is AuthLoaded) {
            return state.authData.householdID == "" ? AddAuthDataToHouseholdView(mainUser: state.authData) : AuthenticatedView(mainUser: state.authData, startCurrentPageIndex: state.startCurrentPageIndex);
          } else if (state is AuthError) {
            return BlocErrorWidget(failure: state.failure, reloadAction: () {
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




