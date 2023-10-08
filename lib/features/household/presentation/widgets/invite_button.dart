import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class InviteButton extends StatelessWidget {
  final String householdId;

  const InviteButton({
    super.key,
    required this.householdId
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          shareLink(householdId);
        },
        icon: const Icon(Icons.person_add),
        label: const Text("Invite User")
    );
  }

  Future<void> shareLink(String householdID) async {

  }
}