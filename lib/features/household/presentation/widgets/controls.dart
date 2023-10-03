import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Controls extends StatefulWidget {
  final String householdId;
  const Controls({
    super.key,
    required this.householdId
  });


  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        loadHousehold(widget.householdId);
      },
      child: const Text("Get Household Data"),
    );
  }

  void loadHousehold(String householdId) {
    BlocProvider.of<HouseholdBloc>(context)
        .add(LoadHouseholdEvent(householdId: householdId));
  }
}