import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/household_task/presentation/widgets/widgets.dart';
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Testing',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)
                  )
                ],
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthInitial) {
                    BlocProvider.of<AuthBloc>(context)
                        .add(LoadAuthEvent());
                    return const Text("Data is loading...");
                  } else if (state is AuthLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is AuthLoaded) {
                    return Column(children: [Text(state.authData.email), Text(state.authData.password)],);
                  } else if (state is AuthError) {
                    return ElevatedButton(onPressed: () async {
                      BlocProvider.of<AuthBloc>(context)
                          .add(const CreateAuthEvent(email: "test", password: "password"));
                    }, child: Text("Create"));
                  } else {
                    return const Text("...");
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}