import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
class AuthenticationWidget extends StatefulWidget {
  const AuthenticationWidget({
    super.key
  });


  @override
  State<AuthenticationWidget> createState() => _AuthenticationWidget();
}

class _AuthenticationWidget extends State<AuthenticationWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String emailStr = '';
  String passwordStr = '';


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Login with your current data"),
          TextField(
              controller: emailController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: 'email',
                  contentPadding: EdgeInsets.all(20)
              ),
              onChanged: (value) {
                emailStr = value;
              }
          ),
          TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: 'password',
                  contentPadding: EdgeInsets.all(20)
              ),
              onChanged: (value) {
                passwordStr = value;
              }
          ),
          ElevatedButton(onPressed: () {
            login(emailStr, passwordStr);
          }, child: const Text("Login")
          )
        ],
      ),
    );
  }

  void login(String email, String password) {
    BlocProvider.of<AuthBloc>(context)
        .add(CreateAuthEvent(email: email, password: password));
  }

}