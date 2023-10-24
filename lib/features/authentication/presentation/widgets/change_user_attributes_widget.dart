import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';


class ChangeUserAttributesWidget extends StatefulWidget {
  final UserChangeType type;
  final BuildContext ancestorContext;

  const ChangeUserAttributesWidget({
    super.key,
    required this.type,
    required this.ancestorContext
  });

  @override
  State<ChangeUserAttributesWidget> createState() => _ChangeUserAttributesWidgetState();
}

class _ChangeUserAttributesWidgetState extends State<ChangeUserAttributesWidget> {

  final TextEditingController textfieldController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController reEnterNewPasswordController = TextEditingController();
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
                        //Password will be added later
                        if(widget.type != UserChangeType.password)
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
                              labelText: widget.type.titleString,
                              hintText: 'test',
                              prefixIcon: Icon(widget.type.icon), // Icon for username
                            ),
                            validator: (value) {
                              return null;
                            },
                            onChanged: (value) {
                              print(value);
                            }
                        ),
                        if (widget.type == UserChangeType.password)
                          TextFormField(
                              controller: newPasswordController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'New password',
                                hintText: 'test',
                                prefixIcon: Icon(widget.type.icon), // Icon for username
                              ),
                              validator: (value) {
                                return null;
                              },
                              onChanged: (value) {
                                print(value);
                              }
                          ),
                          TextFormField(
                              controller: reEnterNewPasswordController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 're enter new password',
                                hintText: 'test',
                                prefixIcon: Icon(widget.type.icon), // Icon for username
                              ),
                              validator: (value) {
                                return null;
                              },
                              onChanged: (value) {
                                print(value);
                              }
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
    Map<String, dynamic> data = {type.stringKey : input};
    //TODO: Password sollte weg
    if (type == UserChangeType.password && confirmationPassword != null && oldPassword != null) {
      data.addAll({
        "oldPassword" : oldPassword,
        "passwordConfirm" : confirmationPassword,
      });
    }

    BlocProvider.of<AuthBloc>(widget.ancestorContext)
        .add(ChangeUserAttributesEvent(data: data, userID: userID));
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
        return "Old Password";
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
