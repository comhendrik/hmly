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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  TaskDetail(task: widget.task,householdId: widget.householdId,)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          tileColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                'Due to ${widget.task.getCurrentDate()}',
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
              Text("Is done: ${widget.task.isDone}"),
              ElevatedButton(onPressed: () {
                updateTask(widget.task.id, widget.task.isDone, widget.householdId);
              }, child: const Text("Testing update")
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateTask(String taskId, bool isDone, String householdId) {
    BlocProvider.of<HouseholdTaskBloc>(context)
        .add(UpdateHouseholdTaskEvent(taskId: taskId, isDone: isDone, householdId: householdId));
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

  //TODO: Access of context


}
