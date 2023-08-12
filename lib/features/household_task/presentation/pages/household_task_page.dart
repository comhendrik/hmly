import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'package:household_organizer/features/household_task/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class HouseholdTaskPage extends StatelessWidget {
  final User mainUser;
  const HouseholdTaskPage({
    super.key,
    required this.mainUser
  });
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<HouseholdTaskBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HouseholdTaskBloc>(),
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                    'Current Tasks',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)
                ),
                Controls(householdId: mainUser.householdId,)
              ],

            ),
            BlocBuilder<HouseholdTaskBloc, HouseholdTaskState>(
              builder: (context, state) {
                if (state is HouseholdTaskInitial) {
                  BlocProvider.of<HouseholdTaskBloc>(context)
                      .add(GetAllTasksForHouseholdEvent(householdId: mainUser.householdId));
                  return const Text("Data is loading...");
                } else if (state is HouseholdTaskLoading) {
                  return const CircularProgressIndicator();
                } else if (state is HouseholdTaskLoaded) {
                  return HouseholdTaskDisplay(mainUser: mainUser, allTasks: state.householdTaskList);
                } else if (state is HouseholdTaskError) {
                  return Text(state.errorMsg);
                } else {
                  return const Text("Error State");
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}


