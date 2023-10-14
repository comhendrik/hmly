import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Controls extends StatefulWidget {
  final String householdID;
  const Controls({
    super.key,
    required this.householdID
  });


  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.update),
          onPressed: () {
            dispatchAllTasksForHousehold();
          },

        )
      ],
    );
  }

  void dispatchAllTasksForHousehold() {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(GetAllTasksForHouseholdEvent(householdID: widget.householdID));
  }

}