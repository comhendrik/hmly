import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmly/core/widgets/custom_button.dart';
import 'package:hmly/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets.dart';


class AuthenticationWidget extends StatefulWidget {


  const AuthenticationWidget({
    super.key
  });


  @override
  State<AuthenticationWidget> createState() => _AuthenticationWidget();
}


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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.house, weight: 5.0),
                Text(AppLocalizations.of(context)!.welcome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              ],
            ),
            const SizedBox(height: 5.0,),
            Text(
              showLogin ? AppLocalizations.of(context)!.login : AppLocalizations.of(context)!.signup,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email,
                hintText: AppLocalizations.of(context)!.emailHint,
                prefixIcon: const Icon(Icons.person), // Icon for username
              ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.validatorMessageNull;
                  }
                  if (!value.contains('@') || !value.contains('.') || value.contains('@.')) {
                    return AppLocalizations.of(context)!.emailValidatorMessage;
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
                hintText: AppLocalizations.of(context)!.passwordHint,
                prefixIcon: const Icon(Icons.lock), // Icon for password
              ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.validatorMessageNull;
                  }
                  if (value.length < 8) {
                    return AppLocalizations.of(context)!.validatorMessagePasswordLength;
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.password,
                      hintText: AppLocalizations.of(context)!.reEnterPasswordHint,
                      prefixIcon: const Icon(Icons.lock), // Icon for password
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.validatorMessageNull;
                      }
                      if (value != passwordStr) {
                        return AppLocalizations.of(context)!.validatorMessagePasswordMatching;
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.username,
                      hintText: AppLocalizations.of(context)!.usernameHint,
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.validatorMessageNull;
                      }

                      if (value.contains(" ")) {
                        return AppLocalizations.of(context)!.validatorMessageValidFormat;
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.fullName,
                      hintText: AppLocalizations.of(context)!.fullNameHint,
                      prefixIcon: const Icon(Icons.badge),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.validatorMessageNull;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      nameStr = value;
                    }
                  ),
                ],
              ),
            CustomIconElevatedButton(
                icon: Icons.arrow_forward,
                buttonText: showLogin ? AppLocalizations.of(context)!.login : AppLocalizations.of(context)!.signup,
                action: () {
                  if (_formKey.currentState!.validate()) {
                    if (showLogin) {
                      login(emailStr, passwordStr);
                    } else {
                      signUp(emailStr, passwordStr, passwordConfirmStr, usernameStr, nameStr);
                    }
                  }
                }
            ),
            CustomElevatedButton(
                buttonText: showLogin ? AppLocalizations.of(context)!.signUpQuestion : AppLocalizations.of(context)!.loginQuestion,
                action: () {
                  setState(() {
                    showLogin = !showLogin;
                  });
                }
            ),
            CustomElevatedButton(
                buttonText: AppLocalizations.of(context)!.forgetPassword,
                action: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (newContext) => ForgetPasswordWidget(ancestorContext: context)
                    ),
                  );
                }
            )
          ],
        ),
      )
    );
  }

  void login(String email, String password) {
    BlocProvider.of<AuthBloc>(context)
        .add(LoginAuthEvent(email: email, password: password));
  }

  void oAuth() {
    BlocProvider.of<AuthBloc>(context)
        .add(const LoadAuthDataWithOAuthEvent());
  }

  void signUp(String email, String password, String passwordConfirm, String username, String name) {
    BlocProvider.of<AuthBloc>(context)
        .add(SignUpAuthEvent(email: email, password: password, passwordConfirm: passwordConfirm, username: username, name: name));
  }
}



