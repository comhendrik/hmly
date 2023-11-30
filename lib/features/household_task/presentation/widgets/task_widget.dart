import 'package:flutter/material.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:hmly/features/household_task/domain/entities/household_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmly/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskWidget extends StatefulWidget {
  final HouseholdTask task;
  final String householdID;
  final User mainUser;

  const TaskWidget({
    super.key,
    required this.task,
    required this.householdID,
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
                  EditableTextField(
                    title: widget.task.title,
                    callback: (data) {
                      updateTask(widget.task, {"title" : data}, widget.householdID);
                    },
                    type: EditableTextFieldType.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15.0,),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      EditableTextField(
                        title: widget.task.getCurrentDate(),
                        callback: (data) {
                          final dueDate = DateTime.parse(data);
                          updateTask(widget.task, {"due_to" : dueDate.toString()}, widget.householdID);
                        },
                        type: EditableTextFieldType.date,
                        style: const TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timeline),
                      EditableTextField(
                        title: widget.task.pointsWorth.toString(),
                        callback: (data) {
                          updateTask(widget.task, {"points_worth" : int.parse(data)}, widget.householdID);
                        },
                        type: EditableTextFieldType.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
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
                      toggleIsDoneHouseholdTask(widget.task, widget.householdID, widget.mainUser.id);
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
                        title: Text(AppLocalizations.of(context)!.warning),
                        content: Text(AppLocalizations.of(context)!.deleteTaskWarning),
                        actions: <Widget>[
                          TextButton(
                            onPressed: ()  => Navigator.pop(context, 'Cancel'),
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteTask(widget.task.id, widget.householdID);
                              Navigator.pop(context, 'Delete');
                            },
                            child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red),),
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

  void toggleIsDoneHouseholdTask(HouseholdTask task, String householdID, String userID) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(ToggleIsDoneHouseholdTaskEvent(task: task, householdID: householdID, userID: userID));
    BlocProvider.of<ChartBloc>(context)
        .add(ReloadInitChartEvent());
  }
  void deleteTask(String taskId, String householdID) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(DeleteHouseholdTaskEvent(taskId: taskId,householdID: householdID));
  }

  void updateTask(HouseholdTask task, Map<String, dynamic> updateData, String householdID) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(UpdateHouseholdTaskEvent(task: task, updateData: updateData, householdID: householdID));
  }

}



