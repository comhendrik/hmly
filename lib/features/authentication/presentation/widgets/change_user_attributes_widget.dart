import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';


class ChangeUserAttributesWidget extends StatefulWidget {
  final UserChangeType type;
  final BuildContext ancestorContext;
  final String mainUserID;

  const ChangeUserAttributesWidget({
    super.key,
    required this.type,
    required this.ancestorContext,
    required this.mainUserID,
  });

  @override
  State<ChangeUserAttributesWidget> createState() => _ChangeUserAttributesWidgetState();
}

class _ChangeUserAttributesWidgetState extends State<ChangeUserAttributesWidget> {

  final TextEditingController textfieldController = TextEditingController();
  final TextEditingController confirmationPasswordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
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
                              Text('Change ${widget.type.titleString}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                            ],
                          ),
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
                              return null;
                            },
                            onChanged: (value) {
                            }
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
                                return null;
                              },
                              onChanged: (value) {
                              }
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
                                return null;
                              },
                              onChanged: (value) {
                              }
                          ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              changeAttribute(textfieldController.text, confirmationPasswordController.text, oldPasswordController.text, widget.mainUserID, widget.type);
                              Navigator.pop(context);
                            }

                          },
                          icon: const Icon(Icons.update),
                          label: const Text("Update Data")
                        ),
                      ],
                    ),
                  )
                )
            ),
          );
        }
    );
  }

  void changeAttribute(String input, String? confirmationPassword, String? oldPassword, String userID, UserChangeType type, ) {
    BlocProvider.of<AuthBloc>(widget.ancestorContext)
        .add(ChangeUserAttributesEvent(input: input, confirmationPassword: confirmationPassword, oldPassword: oldPassword, userID: userID, type: type));
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

  String get titleString {
    switch (this) {
      case UserChangeType.email:
        return "E-Mail";
      case UserChangeType.name:
        return "Name";
      case UserChangeType.username:
        return "Username";
      case UserChangeType. password:
        return "Password";
    }
  }

  String get labelText {
    switch (this) {
      case UserChangeType.email:
        return "New E-Mail";
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
      case UserChangeType.name:
        return "New Name";
      case UserChangeType.username:
        return "New Username";
      case UserChangeType. password:
        return "New Password";
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
