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
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        getLoginOrSignUp(showLogin),
        ElevatedButton(
            onPressed: () {
              //TODO: No Update is happening
              setState(() {
                showLogin = !showLogin;
              });
            },
            child: showLogin ? const Text("No account? Register Now!") : const Text("Already registered? Login!")
        )
      ],
    );
  }



}

Widget getLoginOrSignUp(bool showLogin) {
  if (showLogin)  {
    return const LoginView();
  }
  return const SignUpView();
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});


  @override
  State<LoginView> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {

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

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});


  @override
  State<SignUpView> createState() => _SignUpView();
}

class _SignUpView extends State<SignUpView> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  String emailStr = '';
  String passwordStr = '';
  String passwordConfirmStr = '';
  String usernameStr = '';
  String nameStr = '';

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
          TextField(
              controller: passwordConfirmController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: 'Confirm password',
                  contentPadding: EdgeInsets.all(20)
              ),
              onChanged: (value) {
                passwordConfirmStr = value;
              }
          ),
          TextField(
              controller: usernameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: 'username',
                  contentPadding: EdgeInsets.all(20)
              ),
              onChanged: (value) {
                usernameStr = value;
              }
          ),
          TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: 'name',
                  contentPadding: EdgeInsets.all(20)
              ),
              onChanged: (value) {
                nameStr = value;
              }
          ),
          ElevatedButton(onPressed: () {
            signUp(emailStr, passwordStr, passwordConfirmStr, usernameStr, nameStr);
          }, child: const Text("SignUp")
          )
        ],
      ),
    );
  }

  void signUp(String email, String password, String passwordConfirm, String username, String name) {
    BlocProvider.of<AuthBloc>(context)
        .add(CreateAuthDataOnServerEvent(email: email, password: password, passwordConfirm: passwordConfirm, username: username, name: name));
  }

}