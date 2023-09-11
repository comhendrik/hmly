import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'widgets.dart';

class HouseholdTaskDisplay extends StatelessWidget {
  final User mainUser;
  final List<HouseholdTask> allTasks;

  const HouseholdTaskDisplay({super.key, required this.allTasks, required this.mainUser});

  @override
  Widget build(BuildContext context) {
    if (allTasks.isNotEmpty) {
      return Column(
        children: [
          Column(
              children: getNumberOfTasks(allTasks, 3).map((task){
                return Container(
                  child: TaskWidget(task: task, householdId: mainUser.householdId,),
                );
              }).toList()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,

                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskView(tasks: allTasks, householdId: mainUser.householdId,)),
                  );
                },
                child: const Text('See more'),
              ),
              CreateHouseholdTaskSheet(householdId: mainUser.householdId,),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const Text("There is no Task. Create a new one"),
          CreateHouseholdTaskSheet(householdId: mainUser.householdId,),
        ],
      );
    }
  }
}

List<HouseholdTask> getNumberOfTasks(List<HouseholdTask> list, int number) {
  if (list.length >= number) {
    return list.take(number).toList();
  }
  return list;
}
