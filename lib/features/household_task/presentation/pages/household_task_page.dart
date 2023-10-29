import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/widgets/bloc_error_widget.dart';
import 'package:household_organizer/core/widgets/custom_process_indicator_widget.dart';
import 'package:household_organizer/core/widgets/feauture_widget_blueprint.dart';
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
                  return CustomProcessIndicator(
                    reloadAction: () {
                      BlocProvider.of<HouseholdTaskBloc>(context)
                          .add(GetAllTasksForHouseholdEvent(householdID: mainUser.householdID));
                    }, msg: state.msg,
                  );
                } else if (state is HouseholdTaskLoaded) {
                  return FeatureWidgetBlueprint(
                    title: "Current Tasks",
                    titleIcon: Icons.task,
                    reloadAction: () {
                      BlocProvider.of<HouseholdTaskBloc>(context)
                          .add(GetAllTasksForHouseholdEvent(householdID: mainUser.householdID));
                    },
                    widget: HouseholdTaskMainPage(mainUser: mainUser, allTasks: state.householdTaskList),
                    extraWidget: CreateHouseholdTaskSheet(householdID: mainUser.householdID),
                  );
                } else if (state is HouseholdTaskError) {
                  return BlocErrorWidget(failure: state.failure, reloadAction: () {
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


