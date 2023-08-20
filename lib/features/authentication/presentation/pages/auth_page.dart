import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            return state.authData.householdId == "" ? Text("Create Household or add yourself to one.") : AuthenticatedView(mainUser: state.authData);
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


class AuthenticatedView extends StatefulWidget {
  final User mainUser;
  const AuthenticatedView({super.key, required this.mainUser});


  @override
  State<AuthenticatedView> createState() => _AuthenticatedView();
}

class _AuthenticatedView extends State<AuthenticatedView> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          "Welcome back ${widget.mainUser.name}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        HouseholdTaskPage(mainUser: widget.mainUser,),
        HouseholdPage(mainUser: widget.mainUser,),
        const LogoutButton(),
      ],
    );
  }
}