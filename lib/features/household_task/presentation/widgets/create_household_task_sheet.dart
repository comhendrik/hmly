import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      const Text("Add Task" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Padding(

                        padding: const EdgeInsets.all(10.0),
                        child: TaskInputWidget(onTaskAdded: (title, dueTo, pointsWorth) {
                          createHouseholdTask(widget.householdId, title, pointsWorth, dueTo);
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

  void createHouseholdTask(String householdId, String title, int pointsWorth, DateTime dueTo) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(CreateHouseholdTaskEvent(householdId: householdId, title: title, pointsWorth: pointsWorth, dueTo: dueTo));
  }

}

class TaskInputWidget extends StatefulWidget {
  final Function(String title, DateTime dueTom, int pointsWorth) onTaskAdded;

  const TaskInputWidget({super.key, required this.onTaskAdded});

  @override
  State<TaskInputWidget> createState() => _TaskInputWidgetState();
}

class _TaskInputWidgetState extends State<TaskInputWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _dueToController;


  late TextEditingController _pointsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _dueToController = TextEditingController();
    _pointsController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dueToController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final DateTime dueTo = DateTime.parse(_dueToController.text);
      final int points = int.parse(_pointsController.text);

      setState(() {
        widget.onTaskAdded(title,dueTo,points);
      });

      // Clear the input fields
      _titleController.clear();
      _dueToController.clear();
      _pointsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _dueToController,
            decoration: const InputDecoration(
              labelText: 'Due To (YYYY-MM-DD)',
              prefixIcon: Icon(Icons.calendar_today),
            ),
            validator: (value) {
              if (value == null) {
                return 'Please enter a due date';
              }
              if (!DateTime.tryParse(value)!.isAfter(DateTime.now())) {
                return 'Due date must be in the future';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _pointsController,
            decoration: const InputDecoration(
              labelText: 'Points Worth',
              prefixIcon: Icon(Icons.star),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null) {
                return 'Please enter points worth';
              }
              if (int.tryParse(value) == null || int.parse(value) <= 0) {
                return 'Please enter a valid positive number';
              }
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: const Text('Cancel')
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),

                    onPressed: () {
                      _addTask();
                    },
                    label: const Text('Add Task')
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}