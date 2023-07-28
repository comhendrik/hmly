import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';
class CreateHouseholdTaskSheet extends StatefulWidget {
  const CreateHouseholdTaskSheet({
    super.key
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
      child: ElevatedButton(
        child: const Text('showModalBottomSheet'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height:  MediaQuery.of(context).size.height / 3,
                child: Center(
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
                          ElevatedButton(onPressed: () => createHouseholdTask(inputStr, int.parse(numberStr)), child: const Text("Create New Task")),
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

  void createHouseholdTask(String title, int pointsWorth) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(CreateHouseholdTaskEvent(title: title, pointsWorth: pointsWorth));
  }

}