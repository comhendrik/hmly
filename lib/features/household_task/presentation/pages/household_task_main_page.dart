import 'package:flutter/material.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/features/household_task/domain/entities/household_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/widgets.dart';

class HouseholdTaskMainPage extends StatelessWidget {
  final User mainUser;
  final List<HouseholdTask> allTasks;

  const HouseholdTaskMainPage({super.key, required this.allTasks, required this.mainUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      if (allTasks.isNotEmpty)
        Column(
          children: allTasks.map((task){
            return TaskWidget(task: task, householdID: mainUser.householdID, mainUser: mainUser,);
        }).toList())
      else
        Center(
          child: Text(AppLocalizations.of(context)!.noTaskHint),
        )
      ],
    );
  }
}

