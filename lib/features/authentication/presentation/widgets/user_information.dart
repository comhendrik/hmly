import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';

class UserInformation extends StatefulWidget {

  final User mainUser;

  const UserInformation({
    super.key,
    required this.mainUser
  });

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Logged in as: ${widget.mainUser.name}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Username: ${widget.mainUser.username}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Email: ${widget.mainUser.email}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'ID: ${widget.mainUser.id}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
