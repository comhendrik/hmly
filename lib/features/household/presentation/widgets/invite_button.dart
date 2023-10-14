import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class InviteButton extends StatelessWidget {
  final String householdID;

  const InviteButton({
    super.key,
    required this.householdID
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          shareLink(householdID);
        },
        icon: const Icon(Icons.person_add),
        label: const Text("Invite User")
    );
  }

  Future<void> shareLink(String householdID) async {

  }
}