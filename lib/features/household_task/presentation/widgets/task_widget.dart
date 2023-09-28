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
                  Text(
                    widget.task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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


//TODO: Maybe delete this one here!!!!

class TaskDetail extends StatefulWidget {
  final HouseholdTask task;
  final String householdId;

  const TaskDetail({
    super.key,
    required this.task,
    required this.householdId
  });

  @override
  State<TaskDetail> createState() => _TaskDetailState();

}

class _TaskDetailState extends State<TaskDetail> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }
                    ),
                    Text(
                      widget.task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ],
                ),
                const Text(
                  'Due to:',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                Text(
                    widget.task.getCurrentDate()
                ),
                const Text(
                  'Assigned to',
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                const Text(
                  'Placeholder Hendrik Steen'
                ),
                const Text(
                    'Points Worth:'
                ),
                Text(widget.task.pointsWorth.toString()),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      )
                    ),

                    onPressed: () {



                    },
                    label: Text(widget.task.isDone ? "Undo Task" : "Finish Task")
                  ),
                ),
              ],
            )
        )
    );

  }


}

class DetailInfo extends StatelessWidget {

  /// Widget for showing an Icon besides a text. Used in this application for TaskWidgets in List

  final IconData icon;
  final String title;

  const DetailInfo({
    super.key,
    required this.icon,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        Text(
          '  $title',
          style: const TextStyle(
            fontWeight: FontWeight.w200,
            color: Colors.grey,
          )
        )
      ],
    );
  }

}
