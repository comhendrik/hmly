import 'package:flutter/material.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';

class TaskWidget extends StatefulWidget {
  final HouseholdTask task;
  final String householdId;

  const TaskWidget({
    super.key,
    required this.task,
    required this.householdId
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  bool showControls = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: Column(
        children: [
          ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              tileColor: Colors.white,
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const DetailInfo(icon: Icons.person, title: '<Placeholer>'),
                      DetailInfo(icon: Icons.calendar_month, title: widget.task.getCurrentDate()),
                      DetailInfo(icon: Icons.timeline, title: widget.task.pointsWorth.toString()),



                    ],
                  ),
                ],
              )
          ),
          //TODO: Make disabling controls possible currently impossible, because when updating the state with setState(), wont be reloaded properly
          //if (showControls)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: ElevatedButton.icon(
                        icon: Icon(widget.task.isDone ? Icons.close : Icons.check),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            )
                        ),

                        onPressed: () {
                          updateTask(widget.task.id, widget.task.isDone, widget.householdId);
                        },
                        label: Text(widget.task.isDone ? 'Undo' : 'Finish')
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            )
                        ),

                        onPressed: () {
                          deleteTask(widget.task.id, widget.householdId);
                        },
                        label: const Text('Delete Task')
                    ),
                  ),
                ],
              ),
            )
        ],
      )
    );
  }

  void updateTask(String taskId, bool isDone, String householdId) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(UpdateHouseholdTaskEvent(taskId: taskId, isDone: isDone, householdId: householdId));
  }
  void deleteTask(String taskId, String householdId) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(DeleteHouseholdTaskEvent(taskId: taskId,householdId: householdId));
  }
}

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
