import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';

class AccountView extends StatefulWidget {
  final User mainUser;
  const AccountView({super.key, required this.mainUser});


  @override
  State<AccountView> createState() => _AccountView();
}

class _AccountView extends State<AccountView> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Account:"),
          Text("E-Mail:${widget.mainUser.email}"),
          Text("Username: ${widget.mainUser.username}"),
          Text("Name: ${widget.mainUser.name}"),
          Text("ID: ${widget.mainUser.id}"),
          Text("current household: ${widget.mainUser.householdId}")
        ],
      ),
    );
  }

}