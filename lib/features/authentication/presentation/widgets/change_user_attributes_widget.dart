import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/custom_button.dart';
import 'package:hmly/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ChangeUserAttributesWidget extends StatefulWidget {
  final UserChangeType type;
  final BuildContext ancestorContext;
  final User mainUser;

  const ChangeUserAttributesWidget({
    super.key,
    required this.type,
    required this.ancestorContext,
    required this.mainUser,
  });

  @override
  State<ChangeUserAttributesWidget> createState() => _ChangeUserAttributesWidgetState();
}

class _ChangeUserAttributesWidgetState extends State<ChangeUserAttributesWidget> {


  final TextEditingController textfieldController = TextEditingController();
  TextEditingController? confirmationPasswordController;
  TextEditingController? oldPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.type == UserChangeType.password) {
      confirmationPasswordController = TextEditingController();
      oldPasswordController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) {
          var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return AnimatedPadding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            duration: const Duration(milliseconds: 20),
            child: SafeArea(
                bottom: keyboardHeight <= 0.0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              children: [
                                Text(widget.type.titleString(context), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                              ],
                            ),
                          ),
                          if (widget.type == UserChangeType.password)
                            TextFormField(
                              obscureText: true,
                              controller: oldPasswordController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.password,
                                hintText: AppLocalizations.of(context)!.enterOldPasswordHint,
                                prefixIcon: Icon(widget.type.icon), // Icon for username
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
                            ),
                          TextFormField(
                            obscureText: widget.type == UserChangeType.password,
                            controller: textfieldController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: widget.type.labelText(context),
                              hintText: widget.type.hintText(context),
                              prefixIcon: Icon(widget.type.icon), // Icon for username
                            ),
                            validator: (value) {
                              if (value == null || value == "") {
                                return AppLocalizations.of(context)!.validatorMessageNull;
                              }
                              switch (widget.type) {
                                case UserChangeType.email:
                                  if (!value.contains('@') || !value.contains('.') || value.contains('@.')) {
                                    return AppLocalizations.of(context)!.emailValidatorMessage;
                                  }
                                case UserChangeType.name:
                                  return null;
                                case UserChangeType.username:
                                  if (value.contains(" ")) {
                                    return AppLocalizations.of(context)!.validatorMessageValidFormat;
                                  }
                                case UserChangeType. password:
                                  if (value.length < 8) {
                                    return AppLocalizations.of(context)!.validatorMessagePasswordLength;
                                  }
                              }

                              return null;
                            },
                          ),
                          if (widget.type == UserChangeType.password)
                            TextFormField(
                              obscureText: true,
                              controller: confirmationPasswordController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.password,
                                hintText: AppLocalizations.of(context)!.reEnterPasswordHint,
                                prefixIcon: Icon(widget.type.icon), // Icon for username
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.validatorMessageNull;
                                }
                                if (value != textfieldController.text) {
                                  return AppLocalizations.of(context)!.validatorMessagePasswordMatching;
                                }
                                return null;
                              }
                            ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomIconElevatedButton(
                                icon: Icons.update,
                                buttonText: widget.type.buttonText(context),
                                action: () {
                                  if (!_formKey.currentState!.validate()) return;
                                  if (widget.type == UserChangeType.email) {
                                    requestEmailChange(textfieldController.text, widget.mainUser, widget.ancestorContext);
                                    Navigator.pop(context);
                                    return;
                                  }
                                  changeAttribute(textfieldController.text, confirmationPasswordController?.text, oldPasswordController?.text, widget.mainUser, widget.type, widget.ancestorContext);
                                  Navigator.pop(context);
                                }
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                )
            ),
          );
        }
    );
  }

  void changeAttribute(String input, String? confirmationPassword, String? oldPassword, User user, UserChangeType type, BuildContext bContext) {
    BlocProvider.of<AuthBloc>(bContext)
        .add(ChangeUserAttributesEvent(input: input, confirmationPassword: confirmationPassword, oldPassword: oldPassword, user: user, type: type, context: bContext));
  }

  void requestEmailChange(String newEmail, User user, BuildContext bContext) {
    BlocProvider.of<AuthBloc>(bContext)
        .add(RequestEmailChangeEvent(newEmail: newEmail, user: user, context: bContext));
  }
}

enum UserChangeType {
  email,
  name,
  username,
  password
}

extension UserChangeTypeExtenstion on UserChangeType {


  String get stringKey {
    switch (this) {
      case UserChangeType.email:
        return "email";
      case UserChangeType.name:
        return "name";
      case UserChangeType.username:
        return "username";
      case UserChangeType. password:
        return "password";
    }
  }

  String titleString(BuildContext context) {
    switch (this) {
      case UserChangeType.email:
        return AppLocalizations.of(context)!.changeEmail;
      case UserChangeType.name:
        return AppLocalizations.of(context)!.changeName;
      case UserChangeType.username:
        return AppLocalizations.of(context)!.changeUsername;
      case UserChangeType. password:
        return AppLocalizations.of(context)!.changePassword;
    }
  }

  String labelText(BuildContext context) {
    switch (this) {
      case UserChangeType.email:
        return AppLocalizations.of(context)!.email;
      case UserChangeType.name:
        return AppLocalizations.of(context)!.fullName;
      case UserChangeType.username:
        return AppLocalizations.of(context)!.username;
      case UserChangeType. password:
        return AppLocalizations.of(context)!.password;
    }
  }

  String hintText(BuildContext context) {
    switch (this) {
      case UserChangeType.email:
        return AppLocalizations.of(context)!.hintNewEmail;
      case UserChangeType.name:
        return AppLocalizations.of(context)!.hintNewName;
      case UserChangeType.username:
        return AppLocalizations.of(context)!.hintNewUsername;
      case UserChangeType. password:
        return AppLocalizations.of(context)!.hintNewPassword;
    }
  }

  String buttonText(BuildContext context) {
    switch (this) {
      case UserChangeType.email:
        return AppLocalizations.of(context)!.buttonTextEmail;
      case UserChangeType.name:
        return AppLocalizations.of(context)!.buttonTextFullName;
      case UserChangeType.username:
        return AppLocalizations.of(context)!.buttonTextUsername;
      case UserChangeType. password:
        return AppLocalizations.of(context)!.buttonTextPassword;
    }
  }

  IconData get icon {
    switch (this) {
      case UserChangeType.email:
        return Icons.email;
      case UserChangeType.name:
        return Icons.badge;
      case UserChangeType.username:
        return Icons.password;
      case UserChangeType. password:
        return Icons.lock;
    }
  }


}
