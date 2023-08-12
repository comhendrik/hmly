import 'package:flutter/material.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'widgets.dart';

class TaskView extends StatelessWidget {

  final List<HouseholdTask> tasks;
  const TaskView({super.key, required this.tasks});

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
                for (HouseholdTask task in tasks)
                  TaskWidget(task: task)
              ],
            )
        )
    );
  }
}