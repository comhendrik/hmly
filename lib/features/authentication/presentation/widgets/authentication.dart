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

//TODO: put sign up and login in one widget and add error handling

class _AuthenticationWidget extends State<AuthenticationWidget> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.house, weight: 5.0),
              Text(' Welcome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            ],
          ),
          const SizedBox(height: 5.0,),
          Text(
            showLogin ? 'Login': 'SignUp',
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          getLoginOrSignUp(showLogin),
          ElevatedButton(
              onPressed: () {
                //TODO: No Update is happening
                setState(() {
                  showLogin = !showLogin;
                });
              },
              child: showLogin ? const Text("No account? Register Now!") : const Text("Already registered? Login!")
          ),
        ],
      ),
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
          TextField(
              controller: emailController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'E-Mail',
                hintText: 'Enter your e-mail address',
                prefixIcon: Icon(Icons.person), // Icon for username
              ),
              onChanged: (value) {
                emailStr = value;
              }
          ),
          TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock), // Icon for password
              ),
              onChanged: (value) {
                passwordStr = value;
              }
          ),
          ElevatedButton.icon(
              onPressed: () {
                login(emailStr, passwordStr);
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Login")
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
          TextField(
              controller: emailController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'E-Mail',
                hintText: 'Enter your email address',
                prefixIcon: Icon(Icons.email), // Icon for password
              ),
              onChanged: (value) {
                emailStr = value;
              }
          ),
          TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock), // Icon for password
              ),
              onChanged: (value) {
                passwordStr = value;
              }
          ),
          TextField(
              controller: passwordConfirmController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
                prefixIcon: Icon(Icons.lock), // Icon for password
              ),
              onChanged: (value) {
                passwordConfirmStr = value;
              }
          ),
          TextField(
              controller: usernameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                prefixIcon: Icon(Icons.person), // Icon for password
              ),
              onChanged: (value) {
                usernameStr = value;
              }
          ),
          TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.badge), // Icon for password
              ),
              onChanged: (value) {
                nameStr = value;
              }
          ),
          ElevatedButton.icon(
              onPressed: () {
                signUp(emailStr, passwordStr, passwordConfirmStr, usernameStr, nameStr);
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Sign Up")
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

