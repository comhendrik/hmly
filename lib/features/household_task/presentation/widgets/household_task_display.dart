import 'package:flutter/material.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'widgets.dart';

class HouseholdTaskDisplay extends StatelessWidget {

  final List<HouseholdTask> allTasks;

  HouseholdTaskDisplay({super.key, required this.allTasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
            children: getNumberOfTasks(allTasks, 3).map((task){
              return Container(
                child: TaskWidget(task: task),
              );
            }).toList()),
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
                  MaterialPageRoute(builder: (context) => TaskView(tasks: allTasks)),
                );
              },
              child: const Text('See more'),
            ),
          ],
        ),
      ],
    );
  }
}

List<HouseholdTask> getNumberOfTasks(List<HouseholdTask> list, int number) {
  if (list.length >= number) {
    return list.take(number).toList();
  }
  return list;
}
