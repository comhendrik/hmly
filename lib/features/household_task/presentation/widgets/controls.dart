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
    return ElevatedButton(
      onPressed: () {
        dispatchNews();
      },
      child: const Text("Get Newsss"),
    );
  }

  void dispatchNews() {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(GetAllTasksForHouseholdEvent());
  }
}