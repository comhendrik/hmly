import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmly/core/widgets/custom_button.dart';
import 'package:hmly/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ForgetPasswordWidget extends StatefulWidget {

  final BuildContext ancestorContext;

  const ForgetPasswordWidget({
    super.key,
    required this.ancestorContext
  });


  @override
  State<ForgetPasswordWidget> createState() => _AuthenticationWidget();
}


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
                  Text(AppLocalizations.of(context)!.resetPassword, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                ],
              ),
              const SizedBox(height: 5.0,),
              TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    hintText: AppLocalizations.of(context)!.emailHint,
                    prefixIcon: const Icon(Icons.email), // Icon for username
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
              ),
              CustomIconElevatedButton(
                  icon: Icons.arrow_forward,
                  buttonText: AppLocalizations.of(context)!.requestPasswordReset,
                  action: () {
                    if (_formKey.currentState!.validate()) {
                      requestPasswordReset(emailController.text);
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!.requestSucceedMessage),
                            content: Text(AppLocalizations.of(context)!.emailRequestInfo),
                            actions: <Widget>[
                              TextButton(
                                onPressed: ()  {
                                  Navigator.pop(context, 'Proceed');
                                  Navigator.pop(context);
                                },
                                child: Text(AppLocalizations.of(context)!.proceed),
                              ),
                            ],
                          )
                      );
                    }
                  }
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