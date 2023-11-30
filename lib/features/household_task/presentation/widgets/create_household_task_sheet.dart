import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmly/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateHouseholdTaskSheet extends StatefulWidget {
  final String householdID;
  const CreateHouseholdTaskSheet({
    super.key,
    required this.householdID
  });


  @override
  State<CreateHouseholdTaskSheet> createState() => _CreateHouseholdTaskSheetState();
}

class _CreateHouseholdTaskSheetState extends State<CreateHouseholdTaskSheet> {
  final titleController = TextEditingController();
  final numberController = TextEditingController();
  String inputStr = '';
  String numberStr = '';


  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.assignment_add),
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              return AnimatedPadding(
                padding: EdgeInsets.only(bottom: keyboardHeight),
                duration: const Duration(milliseconds: 20),
                child: SafeArea(
                  bottom: keyboardHeight <= 0.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(AppLocalizations.of(context)!.addTask , style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TaskInputWidget(onTaskAdded: (title, dueTo, pointsWorth) {
                          createHouseholdTask(widget.householdID, title, pointsWorth, dueTo);
                        }),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void createHouseholdTask(String householdID, String title, int pointsWorth, DateTime dueTo) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(CreateHouseholdTaskEvent(householdID: householdID, title: title, pointsWorth: pointsWorth, dueTo: dueTo, context: context));
  }

}
