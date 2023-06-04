import 'package:flutter/material.dart';
import 'package:household_organizer/model/task.dart';
import './task_view.dart';
import 'task_widget.dart';

class HouseholdHome extends StatefulWidget {
  final String householdName;
  const HouseholdHome({super.key, required this.householdName});


  @override
  State<HouseholdHome> createState() => _HouseholdHomeState();
}

class _HouseholdHomeState extends State<HouseholdHome> {
  final List<Task> tasks = Task.getTasks();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.householdName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const Text(
                'Current Tasks',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)
            ),
            for (Task task in getNumberOfTasks(tasks, 3))
              TaskWidget(task: task),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,

                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TaskView()),
                    );
                  },
                  child: const Text('See more'),
                ),
              ],
            )
          ],
        )
      )
    );
  }
}