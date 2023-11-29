import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmly/core/entities/user.dart';
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
            ElevatedButton(
              onPressed: () {
                requestVerification(widget.mainUser);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.email), // Retry icon
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.requestVerification,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                retry();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.refresh), // Retry icon
                  const SizedBox(width: 8),
                  Text(
                      AppLocalizations.of(context)!.reload,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                logout();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.arrow_back), // Retry icon
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => showDialog<String>(
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
                        deleteUser(widget.mainUser);
                        Navigator.pop(context, 'Delete');
                      },
                      child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red),),
                    ),
                  ],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.delete_forever), // Retry icon
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.deleteUserSubtitle,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void requestVerification(User user) {
    BlocProvider.of<AuthBloc>(context)
        .add(RequestVerificationEvent(user: user));
  }

  void retry() {
    BlocProvider.of<AuthBloc>(context)
        .add(LoadAuthEvent());
  }

  void logout() {
    BlocProvider.of<AuthBloc>(context)
        .add(const LogoutEvent());
  }

  void deleteUser(User user) {
    BlocProvider.of<AuthBloc>(context)
        .add(DeleteUserEvent(user: user));
  }
}
