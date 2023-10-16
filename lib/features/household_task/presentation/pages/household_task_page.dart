import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/widgets/bloc_error_widget.dart';
import 'package:household_organizer/core/widgets/custom_process_indicator_widget.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'package:household_organizer/features/household_task/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class HouseholdTaskPage extends StatelessWidget {
  final User mainUser;
  const HouseholdTaskPage({
    super.key,
    required this.mainUser,
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

            BlocBuilder<HouseholdTaskBloc, HouseholdTaskState>(
              builder: (context, state) {
                if (state is HouseholdTaskInitial) {
                  BlocProvider.of<HouseholdTaskBloc>(context)
                      .add(GetAllTasksForHouseholdEvent(householdID: mainUser.householdID));
                  return const Text("Data is loading...");
                } else if (state is HouseholdTaskLoading) {
                  return CustomProcessIndicator(reloadAction: () {
                    BlocProvider.of<HouseholdTaskBloc>(context)
                        .add(GetAllTasksForHouseholdEvent(householdID: mainUser.householdID));
                  });
                } else if (state is HouseholdTaskLoaded) {
                  return HouseholdTaskDisplay(mainUser: mainUser, allTasks: state.householdTaskList);
                } else if (state is HouseholdTaskError) {
                  return BlocErrorWidget(errorMsg: state.errorMsg, reloadAction: () {
                    BlocProvider.of<HouseholdTaskBloc>(context)
                        .add(GetAllTasksForHouseholdEvent(householdID: mainUser.householdID));
                  });
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


