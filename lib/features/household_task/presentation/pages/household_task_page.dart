import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/bloc_error_widget.dart';
import 'package:hmly/core/widgets/custom_process_indicator_widget.dart';
import 'package:hmly/core/widgets/feauture_widget_blueprint.dart';
import 'package:hmly/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'package:hmly/features/household_task/presentation/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      child: BlocBuilder<HouseholdTaskBloc, HouseholdTaskState>(
        builder: (context, state) {
          if (state is HouseholdTaskInitial) {
            loadingFunction(context, mainUser.householdID);
            return const Text("Household Task initialise...");
          } else if (state is HouseholdTaskLoading) {
            return CustomProcessIndicator(reloadAction: () => loadingFunction(context, mainUser.householdID), msg: state.msg);
          } else if (state is HouseholdTaskLoaded) {
            return FeatureWidgetBlueprint(
              title: AppLocalizations.of(context)!.tasksTitle,
              titleIcon: null,
              reloadAction: () => loadingFunction(context, mainUser.householdID),
              widget: HouseholdTaskMainPage(mainUser: mainUser, allTasks: state.householdTaskList),
              extraWidget: CreateHouseholdTaskSheet(householdID: mainUser.householdID),
            );
          } else if (state is HouseholdTaskError) {
            return BlocErrorWidget(failure: state.failure, reloadAction: () => loadingFunction(context, mainUser.householdID));
          } else {
            return const Text("Please contact support when this occurs");
          }
        },
      ),
    );
  }

  void loadingFunction(BuildContext bContext, String householdID) {
    BlocProvider.of<HouseholdTaskBloc>(bContext)
        .add(GetAllTasksForHouseholdEvent(householdID: householdID));
  }
}


