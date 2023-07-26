import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'package:household_organizer/features/household_task/presentation/widgets/task_view.dart';
import 'package:household_organizer/features/household_task/presentation/widgets/task_widget.dart';
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
              // Top half
              BlocBuilder<HouseholdTaskBloc, HouseholdTaskState>(
                builder: (context, state) {
                  if (state is HouseholdTaskInitial) {
                    return const Text("Yaayy, there is nothing to do");
                  } else if (state is HouseholdTaskLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is HouseholdTaskLoaded) {
                    return Column(
                      children: [
                        Column(
                        children: getNumberOfTasks(state.householdTaskList, 3).map((task){
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
                                  MaterialPageRoute(builder: (context) => TaskView(tasks: state.householdTaskList)),
                                );
                              },
                              child: const Text('See more'),
                            ),
                          ],
                        ),
                      ],
                    );
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

List<HouseholdTask> getNumberOfTasks(List<HouseholdTask> list, int number) {
  if (list.length >= number) {
    return list.take(number).toList();
  }
  return list;
}

