import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';

class TaskWidget extends StatefulWidget {
  final HouseholdTask task;
  final String householdId;
  final User mainUser;

  const TaskWidget({
    super.key,
    required this.task,
    required this.householdId,
    required this.mainUser
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  bool showControls = false;
  bool isEditingTitle = false;
  final titleEditingController = TextEditingController();
  String titleStr = "";

  @override
  void initState() {
    super.initState();
    titleStr = widget.task.title;
    titleEditingController.text = titleStr;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: Card(
        elevation: 0.125,
        color: widget.task.isDone ? Colors.green.shade50 : Colors.white,
        // No elevation for the Card; we'll use the shadow from the Container
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditingTitle = !isEditingTitle;
                      });
                    },
                    child: isEditingTitle ?
                    Container(
                      width: 100, // Adjust the width as per your preference
                      child: TextField(
                        controller: titleEditingController,
                        onEditingComplete: () {
                          setState(() {
                            isEditingTitle = false;
                          });
                          updateTask(widget.task, {"title" : titleStr}, widget.householdId);
                        },
                        onChanged: (value) {
                          titleStr = value;
                        },
                        style: const TextStyle(fontSize: 12),
                        // Adjust the font size
                      ),
                    )
                    : Text(
                      titleStr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0,),
                  DetailInfo(icon: Icons.calendar_month, title: widget.task.getCurrentDate(), callback: (data) {
                    //TODO: Error handling
                    final due_date = DateTime.parse(data);
                    updateTask(widget.task, {"due_to" : due_date.toString()}, widget.householdId);
                  }, type: EditableTextFieldType.date, textStyle: const TextStyle(
                    fontWeight: FontWeight.w200,
                    color: Colors.grey,
                  ),),
                  DetailInfo(icon: Icons.timeline, title: widget.task.pointsWorth.toString(), callback: (data) {
                    //TODO: Error handling
                    updateTask(widget.task, {"points_worth" : int.parse(data)}, widget.householdId);
                  }, type: EditableTextFieldType.number, textStyle: const TextStyle(
                    fontWeight: FontWeight.w200,
                    color: Colors.grey,
                  ),),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(widget.task.isDone ? Icons.close : Icons.check),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),

                    onPressed: () {
                      toggleIsDoneHouseholdTask(widget.task, widget.householdId, widget.mainUser.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Delete Warning'),
                        content: const Text('Do you really want to delete this task?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: ()  => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteTask(widget.task.id, widget.householdId);
                              Navigator.pop(context, 'Delete');
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        )
      ),
    );
  }

  void toggleIsDoneHouseholdTask(HouseholdTask task, String householdId, String userId) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(ToggleIsDoneHouseholdTaskEvent(task: task, householdId: householdId, userId: userId));
  }
  void deleteTask(String taskId, String householdId) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(DeleteHouseholdTaskEvent(taskId: taskId,householdId: householdId));
  }

  void updateTask(HouseholdTask task, Map<String, dynamic> updateData, String householdId) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(UpdateHouseholdTaskEvent(task: task, updateData: updateData, householdId: householdId));
  }

}

//TODO: Maybe delete this one
class DetailInfo extends StatefulWidget {
  final IconData icon;
  final String title;
  final Function(String) callback;
  final EditableTextFieldType type;
  final TextStyle textStyle;

  const DetailInfo({
    super.key,
    required this.icon,
    required this.title,
    required this.callback,
    required this.type,
    required this.textStyle
  });

  @override
  State<DetailInfo> createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(widget.icon),
        EditableTextField(title: widget.title, callback: (data) {widget.callback(data);}, type: widget.type, style: widget.textStyle,)

      ],
    );
  }
}

class EditableTextField extends StatefulWidget {
  final String title;
  final Function(String) callback;
  final EditableTextFieldType type;
  final TextStyle style;

  const EditableTextField({
    super.key,
    required this.title,
    required this.callback,
    required this.type,
    required this.style
  });

  @override
  State<EditableTextField> createState() => _EditableTextFieldState();

}

class _EditableTextFieldState extends State<EditableTextField> {

  bool showTextField = false;
  final textEditionController = TextEditingController();
  String textStr = "";
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    textStr = widget.title;
    textEditionController.text = textStr;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          setState(() {
            showTextField = !showTextField;
          });
        },
        child: showTextField ?
        Container(
          width: 100, // Adjust the width as per your preference
          child: TextFormField(
            controller: textEditionController,
            onEditingComplete: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  showTextField = false;
                });
                widget.callback(textStr);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'provide a value';
              }
              switch (widget.type) {
                case EditableTextFieldType.date:
                  if (DateTime.tryParse(value) == null) {
                    return 'enter valid date';
                  }
                  if (!DateTime.tryParse(value)!.isAfter(DateTime.now())) {
                    return 'Due date must be in the future';
                  }
                  return null;
                case EditableTextFieldType.number:
                  if (value == null || value.isEmpty) {
                    return 'Please enter points worth';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                case EditableTextFieldType.text:
                  return null;
              }
            },
            onChanged: (value) {
              textStr = value;
            },
            style: const TextStyle(fontSize: 12),
            // Adjust the font size
          ),
        )
            : Text(
          textStr,
          style: widget.style
        ),
      ),
    );
  }
}

enum EditableTextFieldType {
  date,
  number,
  text
}


