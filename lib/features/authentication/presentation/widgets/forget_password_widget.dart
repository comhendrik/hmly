import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';


class ForgetPasswordWidget extends StatefulWidget {

  final BuildContext ancestorContext;

  const ForgetPasswordWidget({
    super.key,
    required this.ancestorContext
  });


  @override
  State<ForgetPasswordWidget> createState() => _AuthenticationWidget();
}

//TODO: put sign up and login in one widget and add error handling

class _AuthenticationWidget extends State<ForgetPasswordWidget> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)
                  ),
                  const Icon(Icons.lock, weight: 5.0),
                  const Text(' Reset Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                ],
              ),
              const SizedBox(height: 5.0,),
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
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      requestPasswordReset(emailController.text);
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Request send successfully'),
                            content: const Text('Check your E-Mail for a link to reset your password'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: ()  {
                                  Navigator.pop(context, 'Okay');
                                  Navigator.pop(context);
                                },
                                child: const Text('Okay'),
                              ),
                            ],
                          )
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Request Password Reset")
              ),

            ],
          ),
        ),
      ),
    );
  }

  void requestPasswordReset(String userEmail) {
    BlocProvider.of<AuthBloc>(widget.ancestorContext)
        .add(RequestNewPasswordEvent(userEmail: userEmail));
  }
}