import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'package:household_organizer/features/household_task/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class HouseholdTaskPage extends StatelessWidget {

  const HouseholdTaskPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<HouseholdTaskBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HouseholdTaskBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      'Current Tasks',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)
                  ),
                ],
              ),
              BlocBuilder<HouseholdTaskBloc, HouseholdTaskState>(
                builder: (context, state) {
                  if (state is HouseholdTaskInitial) {
                    return const Text("Yaayy, there is nothing to do");
                  } else if (state is HouseholdTaskLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is HouseholdTaskLoaded) {
                    return HouseholdTaskDisplay(allTasks: state.householdTaskList);
                  } else if (state is HouseholdTaskError) {
                    return Text(state.errorMsg);
                  } else {
                    return const Text("...");
                  }
                },
              ),
              // Bottom half
              const Controls()
            ],
          ),
        ),
      ),
    );
  }
}


