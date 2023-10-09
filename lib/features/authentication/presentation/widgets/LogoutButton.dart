import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final _storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            //TODO: Clear pocketbase authentication session
            await _storage.delete(key: "email");
            await _storage.delete(key: "password");
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