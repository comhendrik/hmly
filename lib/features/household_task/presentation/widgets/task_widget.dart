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
                  DetailInfo(icon: Icons.calendar_month, title: widget.task.getCurrentDate()),
                  DetailInfo(icon: Icons.timeline, title: widget.task.pointsWorth.toString()),
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
                      updateTask(widget.task, widget.householdId, widget.mainUser.id);
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

  void updateTask(HouseholdTask task, String householdId, String userId) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(UpdateHouseholdTaskEvent(task: task, householdId: householdId, userId: userId));
  }
  void deleteTask(String taskId, String householdId) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(DeleteHouseholdTaskEvent(taskId: taskId,householdId: householdId));
  }

}

class DetailInfo extends StatefulWidget {
  final IconData icon;
  final String title;

  const DetailInfo({
    super.key,
    required this.icon,
    required this.title
  });

  @override
  State<DetailInfo> createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {

  bool showTextField = false;
  final textEditionController = TextEditingController();
  String textStr = "";


  @override
  void initState() {
    super.initState();
    textStr = widget.title;
    textEditionController.text = textStr;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(widget.icon),
        GestureDetector(
          onTap: () {
            setState(() {
              showTextField = true;
            });
          },
          child: showTextField ?
          Container(
            width: 100, // Adjust the width as per your preference
            child: TextField(
              controller: textEditionController,
              onEditingComplete: () {
                setState(() {
                  showTextField = false;
                });
              },
              onChanged: (value) {
                textStr = value;
              },
              style: const TextStyle(fontSize: 12),
              // Adjust the font size
            ),
          )
          :
          Text('  $textStr',
              style: const TextStyle(
                fontWeight: FontWeight.w200,
                color: Colors.grey,
              )
          )
        ),

      ],
    );
  }
}

