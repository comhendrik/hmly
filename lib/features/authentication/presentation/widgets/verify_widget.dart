import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'widgets.dart';

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
    return Center(
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
          const Text(
            "You are not verified",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please click the button below to request an verification email. After validating, reload application or click on retry',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              requestVerification(widget.mainUser);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.email), // Retry icon
                SizedBox(width: 8),
                Text(
                  'Request Verification',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              retry();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.refresh), // Retry icon
                SizedBox(width: 8),
                Text(
                  'Try again',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              logout();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.arrow_back), // Retry icon
                SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          UserInformation(mainUser: widget.mainUser)
        ],
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
}
