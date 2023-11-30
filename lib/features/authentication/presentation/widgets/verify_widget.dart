import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/custom_button.dart';
import 'package:hmly/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyWidget extends StatefulWidget {
  final User mainUser;

  const VerifyWidget({
    super.key,
    required this.mainUser
  });

  @override
  State<VerifyWidget> createState() => _VerifyWidgetState();
}

class _VerifyWidgetState extends State<VerifyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error, // Error icon
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.notVerified(widget.mainUser.email),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.verificationInformation,
              style: const TextStyle(fontSize: 18,),
            ),
            const SizedBox(height: 24),
            CustomIconElevatedButton(
                icon: Icons.email,
                buttonText: AppLocalizations.of(context)!.requestVerification,
                action: () {
                  requestVerification(widget.mainUser, context);
                }
            ),
            CustomIconElevatedButton(
                icon: Icons.refresh,
                buttonText: AppLocalizations.of(context)!.reload,
                action: () {
                  retry(context);
                }
            ),
            CustomIconElevatedButton(
                icon: Icons.arrow_back,
                buttonText: AppLocalizations.of(context)!.logout,
                action: () {
                  logout(context);
                }
            ),
            CustomIconElevatedButton(
                icon: Icons.delete_forever,
                buttonText: AppLocalizations.of(context)!.deleteUserSubtitle,
                action: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!.warning),
                    content: Text(AppLocalizations.of(context)!.deleteUserAlert),
                    actions: <Widget>[
                      TextButton(
                        onPressed: ()  => Navigator.pop(context, 'Cancel'),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteUser(widget.mainUser, context);
                          Navigator.pop(context, 'Delete');
                        },
                        child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red),),
                      ),
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  void requestVerification(User user, BuildContext bContext) {
    BlocProvider.of<AuthBloc>(bContext)
        .add(RequestVerificationEvent(user: user, context: bContext));
  }

  void retry(BuildContext bContext) {
    BlocProvider.of<AuthBloc>(bContext)
        .add(LoadAuthEvent(context: bContext));
  }

  void logout(BuildContext bContext) {
    BlocProvider.of<AuthBloc>(bContext)
        .add(LogoutEvent(context: bContext));
  }

  void deleteUser(User user, BuildContext bContext) {
    BlocProvider.of<AuthBloc>(context)
        .add(DeleteUserEvent(user: user, context: bContext));
  }
}
