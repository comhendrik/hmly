import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
class CreateHouseholdTaskSheet extends StatefulWidget {
  final String householdId;
  const CreateHouseholdTaskSheet({
    super.key,
    required this.householdId
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
              var keyboardHeight = MediaQuery.of(context).viewInsets.bottom ?? 0.0;
              return AnimatedPadding(
                padding: EdgeInsets.only(bottom: keyboardHeight),
                duration: Duration(milliseconds: 20),
                child: SafeArea(
                  bottom: keyboardHeight <= 0.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: 'Enter a title',
                              contentPadding: EdgeInsets.all(20)
                          ),
                          onChanged: (value) {
                            inputStr = value;
                          }
                      ),
                      TextField(
                          controller: numberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: 'Enter how many points the task is worth',
                              contentPadding: EdgeInsets.all(20)
                          ),
                          onChanged: (value) {
                            numberStr = value;
                          }
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.cancel_outlined, color: Colors.red,),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(onPressed: () => createHouseholdTask(widget.householdId, inputStr, int.parse(numberStr)), child: const Text("Create New Task")),
                        ],
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

  void createHouseholdTask(String householdId, String title, int pointsWorth) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(CreateHouseholdTaskEvent(householdId: householdId, title: title, pointsWorth: pointsWorth));
  }

}