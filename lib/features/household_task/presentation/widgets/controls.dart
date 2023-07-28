import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Controls extends StatefulWidget {
  const Controls({
    super.key
  });


  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            dispatchAllTasksForHousehold();
          },
          child: const Text("Get Tasks"),
        )
      ],
    );
  }

  void dispatchAllTasksForHousehold() {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(GetAllTasksForHouseholdEvent());
  }

}