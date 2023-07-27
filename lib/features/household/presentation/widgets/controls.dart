import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
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
      child: const Text("Get Household Data"),
    );
  }

  void dispatchNews() {
    BlocProvider.of<HouseholdBloc>(context)
        .add(LoadHouseholdEvent());
  }
}