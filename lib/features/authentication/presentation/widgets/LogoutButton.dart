import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({
    super.key
  });


  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            if (!context.mounted) return;
            BlocProvider.of<AuthBloc>(context)
                .add(const LogoutEvent());
          },
          child: const Text("Logout"),
        )
      ],
    );
  }

}