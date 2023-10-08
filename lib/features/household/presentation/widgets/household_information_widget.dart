import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import 'widget.dart';
import 'package:flutter_share/flutter_share.dart';

class HouseholdInformationWidget extends StatefulWidget {
  final BuildContext context;
  final Household household;
  const HouseholdInformationWidget({
    super.key,
    required this.context,
    required this.household
  });

  @override
  State<HouseholdInformationWidget> createState() => _HouseholdInformationWidgetState();
}

class _HouseholdInformationWidgetState extends State<HouseholdInformationWidget> {

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
          HouseholdInformationCard(
            action: () {
              if (_formKey.currentState!.validate()) {
                updateHouseholdTitle(widget.household.id, titleStr);
                Navigator.pop(context);
              }
            },
            title: "Household Title",
            titleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Current:"),
                Text(widget.household.title)
              ],
            ),
            detailWidget: TextFormField(
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
            buttonIcon: const Icon(Icons.update),
            buttonText: 'Update',
          ),
          const SizedBox(height: 10,),
          HouseholdInformationCard(
              action: () {
                Clipboard.setData(ClipboardData(text: widget.household.id))
                  .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied ID: '${widget.household.id}'"))));
              },
              title: "Household Id",
              titleWidget: null,
              detailWidget: Text(widget.household.id),
              buttonIcon: const Icon(Icons.save),
              buttonText: 'Copy ID'
          ),
          const SizedBox(height: 10,),
          HouseholdInformationCard(
              action: () async {
                await FlutterShare.share(
                    title: 'Invite Link',
                    text: "I wanted to invite you to my household. Use this ID '${widget.household.id}' to join my household",
                    linkUrl: 'https://test.com/${widget.household.id}'
                );
              },
              title: "User",
              titleWidget: null,
              detailWidget: Column(
                children: [
                  for (User user in widget.household.users)
                    Text(user.name)
                ],
              ),
              buttonIcon: const Icon(Icons.person_add),
              buttonText: 'Invite User'
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
