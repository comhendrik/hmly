import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseholdTaskDisplay extends StatelessWidget {
  final User mainUser;
  final List<HouseholdTask> allTasks;

  const HouseholdTaskDisplay({super.key, required this.allTasks, required this.mainUser});

  @override
  Widget build(BuildContext context) {
    if (allTasks.isNotEmpty) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                  'Current Tasks',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)
              ),
              CreateHouseholdTaskSheet(householdID: mainUser.householdID,),
              Controls(householdID: mainUser.householdID,)
            ],

          ),
          Column(
              children: allTasks.map((task){
                return Container(
                  child: TaskWidget(task: task, householdID: mainUser.householdID, mainUser: mainUser,),
                );
              }).toList()),
        ],
      );
    } else {
      return Column(
        children: [
          const Text("There is no Task. Create a new one"),
          CreateHouseholdTaskSheet(householdID: mainUser.householdID,),
        ],
      );
    }
  }
}

