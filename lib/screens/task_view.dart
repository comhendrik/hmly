import 'package:flutter/material.dart';
import 'package:household_organizer/model/task.dart';
import 'task_widget.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskView();
}

class _TaskView extends State<TaskView> {
  final List<Tasks> tasks = Tasks.getTasks();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }
                    ),
                    const Text(
                      'All Tasks',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ],
                ),
                for (Tasks task in tasks)
                  TaskWidget(task: task)
              ],
            )
        )
    );
  }
}