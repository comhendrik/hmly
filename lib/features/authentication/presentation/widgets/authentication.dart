import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'widgets.dart';


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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
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
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-Mail',
                hintText: 'Enter your e-mail address',
                prefixIcon: Icon(Icons.person), // Icon for username
              ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an e-mail adress';
                  }
                  if (!value.contains('@') || !value.contains('.') || value.contains('@.')) {
                    return 'No valid email';
                  }
                  return null;
                },
              onChanged: (value) {
                emailStr = value;
              }
            ),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock), // Icon for password
              ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Use at least 8 characters for your password';
                  }
                  return null;
                },
              onChanged: (value) {
                passwordStr = value;
              }
            ),
            if (!showLogin)
              Column(
                children: [
                  TextFormField(
                    obscureText: true,
                    controller: passwordConfirmController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      prefixIcon: Icon(Icons.lock), // Icon for password
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password';
                      }
                      if (value != passwordStr) {
                        return 'The passwords arent matching';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      passwordConfirmStr = value;
                    }
                  ),
                  TextFormField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.person), // Icon for password
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      usernameStr = value;
                    }
                  ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                      prefixIcon: Icon(Icons.badge), // Icon for password
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      nameStr = value;
                    }
                  ),
                ],
              ),
            ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (showLogin) {
                      login(emailStr, passwordStr);
                    } else {
                      signUp(emailStr, passwordStr, passwordConfirmStr, usernameStr, nameStr);
                    }
                  }
                },
                icon: const Icon(Icons.arrow_forward),
                label: Text(showLogin ? "Login" : "SignUp")
            ),
            SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: () {
                oAuth();
              },
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    showLogin = !showLogin;
                  });
                },
                child: showLogin ? const Text("No account? Register Now!") : const Text("Already registered? Login!")
            ),


            Text("Dev widget:"),
            const LogoutButton(),
          ],
        ),
      )
    );
  }

  void login(String email, String password) {
    BlocProvider.of<AuthBloc>(context)
        .add(CreateAuthEvent(email: email, password: password));
  }

  void oAuth() {
    BlocProvider.of<AuthBloc>(context)
        .add(const LoadAuthDataWithOAuthEvent());
  }


  void signUp(String email, String password, String passwordConfirm, String username, String name) {
    BlocProvider.of<AuthBloc>(context)
        .add(CreateAuthDataOnServerEvent(email: email, password: password, passwordConfirm: passwordConfirm, username: username, name: name));
  }
}



