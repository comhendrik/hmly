import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/domain/usecases/delete_auth_data_from_household.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:household_organizer/features/charts/presentation/pages/chart_page.dart';
import 'package:household_organizer/features/charts/presentation/widgets/bar_chart.dart';
import 'package:household_organizer/features/charts/presentation/widgets/pie_chart.dart';
import 'package:household_organizer/features/household/presentation/pages/household_page.dart';
import 'package:household_organizer/features/household_task/presentation/pages/household_task_page.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/LogoutButton.dart';


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
            return state.authData.householdId == "" ? AddAuthDataToHouseholdView(user: state.authData) : AuthenticatedView(mainUser: state.authData);
          } else if (state is AuthError) {
            return Text(state.errorMsg);
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




