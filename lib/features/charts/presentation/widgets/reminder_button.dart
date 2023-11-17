import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class ReminderButton extends StatelessWidget {
  final int dailyPoints;

  const ReminderButton({
    super.key,
    required this.dailyPoints
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: ElevatedButton.icon(
          icon: const Icon(Icons.check),
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
              )
          ),
          onPressed: () {
            shareLink(dailyPoints);
          },
          label: const Text("Remind your household to do tasks")
      ),
    );
  }

  Future<void> shareLink(int dailyPoints) async {
    await FlutterShare.share(
      title: 'Task Reminder',
      text: 'I just wanted to remind you of doing your tasks, I already got $dailyPoints today',
      linkUrl: 'https://test.com'
    );
  }
}