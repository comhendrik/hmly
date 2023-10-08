import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';

class UpdateHouseholdTitle extends StatefulWidget {
  final BuildContext context;
  final Household household;
  const UpdateHouseholdTitle({
    super.key,
    required this.context,
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
  void initState() {
    titleController.text = widget.household.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Household Title", style: TextStyle(fontWeight: FontWeight.bold),),
                        const Text("Current:"),
                        Text(widget.household.title)
                      ],
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updateHouseholdTitle(widget.household.id, titleStr);
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.update),
                        label: const Text("Update")
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter title',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    titleStr = titleController.text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    if (value.length >= 15) {
                      return 'Must be less than 15 characters.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  void updateHouseholdTitle(String householdId, String householdTitle) {
    BlocProvider.of<HouseholdBloc>(widget.context)
        .add(UpdateHouseholdTitleEvent(householdId: householdId, householdTitle: householdTitle));
  }
}
