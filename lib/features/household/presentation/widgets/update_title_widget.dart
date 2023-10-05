import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';

class UpdateHouseholdTitle extends StatefulWidget {
  final Household household;
  const UpdateHouseholdTitle({
    super.key,
    required this.household
  });

  @override
  State<UpdateHouseholdTitle> createState() => _UpdateHouseholdTitleState();
}

class _UpdateHouseholdTitleState extends State<UpdateHouseholdTitle> {

  final titleController = TextEditingController();
  String titleStr = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text('Household: ${widget.household.title}', style: const TextStyle(color: Colors.grey),),
        TextField(
          controller: titleController,
          onChanged: (value) {
            titleStr = value;
          },
        ),
        ElevatedButton.icon(
            onPressed: () {
              updateHouseholdTitle(widget.household.id, titleStr);
            },
            icon: const Icon(Icons.update),
            label: const Text("Update")
        )
      ],
    );
  }

  void updateHouseholdTitle(String householdId, String householdTitle) {
    BlocProvider.of<HouseholdBloc>(context)
        .add(UpdateHouseholdTitleEvent(householdId: householdId, householdTitle: householdTitle));
  }
}
