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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child:Column(
        children: [

          Text('Household: ${widget.household.title}', style: const TextStyle(color: Colors.grey),),
          TextFormField(
            controller: titleController,

            onChanged: (value) {
              titleStr = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updateHouseholdTitle(widget.household.id, titleStr);
                }
              },
              icon: const Icon(Icons.update),
              label: const Text("Update")
          )
        ],
      )
    );
  }

  void updateHouseholdTitle(String householdId, String householdTitle) {
    BlocProvider.of<HouseholdBloc>(context)
        .add(UpdateHouseholdTitleEvent(householdId: householdId, householdTitle: householdTitle));
  }
}
