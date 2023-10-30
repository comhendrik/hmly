import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';


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


  //TODO: Maybe some of them only need to be init when using right type: like the password ones
  final TextEditingController textfieldController = TextEditingController();
  final TextEditingController confirmationPasswordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController verificationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                                Text(widget.type.titleString, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                              ],
                            ),
                          ),
                          if (widget.type == UserChangeType.password)
                            TextFormField(
                              controller: oldPasswordController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'old password',
                                hintText: 'old password',
                                prefixIcon: Icon(widget.type.icon), // Icon for username
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
                            ),
                          TextFormField(
                            controller: textfieldController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: widget.type.labelText,
                              hintText: widget.type.hintText,
                              prefixIcon: Icon(widget.type.icon), // Icon for username
                            ),
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Please provide a value";
                              }
                              switch (widget.type) {
                                case UserChangeType.email:
                                  if (!value.contains('@') || !value.contains('.') || value.contains('@.')) {
                                    return 'No valid email';
                                  }
                                case UserChangeType.verifyEmail:
                                  if (value.length < 8) {
                                    return 'Use at least 8 characters for your password';
                                  }
                                case UserChangeType.name:
                                //Nothing needed
                                case UserChangeType.username:
                                  if (value.contains(" ")) {
                                    return 'Must be in a valid format';
                                  }
                                case UserChangeType. password:
                                  if (value.length < 8) {
                                    return 'Use at least 8 characters for your password';
                                  }
                              }

                              return null;
                            },
                          ),
                          if (widget.type == UserChangeType.password)
                            TextFormField(
                                controller: confirmationPasswordController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 're enter new password',
                                  hintText: 're enter new password',
                                  prefixIcon: Icon(widget.type.icon), // Icon for username
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please re-enter your password';
                                  }
                                  if (value != textfieldController.text) {
                                    return 'The passwords arent matching';
                                  }
                                  return null;
                                }
                            ),
                          if (widget.type == UserChangeType.verifyEmail)
                            TextFormField(
                              controller: verificationController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Verify Token',
                                hintText: 'your token from email',
                                prefixIcon: Icon(widget.type.icon), // Icon for username
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the token';
                                }
                                return null;
                              },
                            ),

                          if (widget.type == UserChangeType.email)
                            TextFormField(
                              obscureText: true,
                              controller: verificationController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'password',
                                hintText: 'enter password',
                                prefixIcon: Icon(widget.type.icon), // Icon for username
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please provide a value';
                                }
                                if (value.length < 8) {
                                  return 'Use at least 8 characters for your password';
                                }
                                return null;
                              },
                            ),
                          ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  changeAttribute(textfieldController.text, verificationController.text, confirmationPasswordController.text, oldPasswordController.text, widget.mainUser, widget.type);
                                  Navigator.pop(context);
                                }
                              },
                              icon: const Icon(Icons.update),
                              label: Text(widget.type.buttonText)
                          ),
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

  void changeAttribute(String input, String? token, String? confirmationPassword, String? oldPassword, User user, UserChangeType type, ) {
    BlocProvider.of<AuthBloc>(widget.ancestorContext)
        .add(ChangeUserAttributesEvent(input: input, token: token, confirmationPassword: confirmationPassword, oldPassword: oldPassword, user: user, type: type));
  }

  void requestEmailChange(String newEmail) {
    print(newEmail);
  }
}

enum UserChangeType {
  email,
  verifyEmail,
  name,
  username,
  password
}

extension UserChangeTypeExtenstion on UserChangeType {

  String get stringKey {
    switch (this) {
      case UserChangeType.email:
        return "email";
      case UserChangeType.verifyEmail:
        return "email";
      case UserChangeType.name:
        return "name";
      case UserChangeType.username:
        return "username";
      case UserChangeType. password:
        return "password";
    }
  }

  String get titleString {
    switch (this) {
      case UserChangeType.email:
        return "Change E-Mail";
      case UserChangeType.verifyEmail:
        return "Verify New Email";
      case UserChangeType.name:
        return "Change Name";
      case UserChangeType.username:
        return "Change Username";
      case UserChangeType. password:
        return "Change Password";
    }
  }

  String get labelText {
    switch (this) {
      case UserChangeType.email:
        return "Email";
      case UserChangeType.verifyEmail:
        return "Password";
      case UserChangeType.name:
        return "New Name";
      case UserChangeType.username:
        return "New Username";
      case UserChangeType. password:
        return "New Password";
    }
  }

  String get hintText {
    switch (this) {
      case UserChangeType.email:
        return "New E-Mail";
      case UserChangeType.verifyEmail:
        return "enter password";
      case UserChangeType.name:
        return "New Name";
      case UserChangeType.username:
        return "New Username";
      case UserChangeType. password:
        return "New Password";
    }
  }

  String get buttonText {
    switch (this) {
      case UserChangeType.email:
        return "Request E-Mail Change";
      case UserChangeType.verifyEmail:
        return "Verify new E-Mail";
      case UserChangeType.name:
        return "Update Name";
      case UserChangeType.username:
        return "Update Username";
      case UserChangeType. password:
        return "Update Password";
    }
  }

  IconData get icon {
    switch (this) {
      case UserChangeType.email:
        return Icons.email;
      case UserChangeType.verifyEmail:
        return Icons.lock;
      case UserChangeType.name:
        return Icons.badge;
      case UserChangeType.username:
        return Icons.password;
      case UserChangeType. password:
        return Icons.lock;
    }
  }

}
