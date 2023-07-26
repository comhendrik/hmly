import 'package:flutter/material.dart';
import 'package:household_organizer/model/task.dart';
import 'package:household_organizer/screens/pie_chart.dart';
import './bar_chart.dart';
import '../features/household_task/presentation/widgets/task_view.dart';
import '../features/household_task/presentation/widgets/task_widget.dart';
import 'package:household_organizer/db/test.dart';

import 'package:household_organizer/features/household_task/presentation/pages/household_task_page.dart';

class HouseholdHome extends StatefulWidget {
  final String householdName;
  const HouseholdHome({super.key, required this.householdName});


  @override
  State<HouseholdHome> createState() => _HouseholdHomeState();
}

class _HouseholdHomeState extends State<HouseholdHome> {
  final List<Tasks> tasks = Tasks.getTasks();

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
                const HouseholdTaskPage(),
              ],
            )
        )
    );
  }
}