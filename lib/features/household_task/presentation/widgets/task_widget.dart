import 'package:flutter/material.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';

class TaskWidget extends StatelessWidget {
  final HouseholdTask task;
  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  TaskDetail(task: task)),
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
                task.title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                'Due to ${task.getCurrentDate()}',
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskDetail extends StatelessWidget {
  final HouseholdTask task;
  const TaskDetail({super.key, required this.task});

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
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ],
                ),
                const Text(
                  'Due to:',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                Text(
                  task.getCurrentDate()
                ),
                const Text(
                  'Assigned to',
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                const Text(
                  'Hendrik Steen'
                ),
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

                    onPressed: () {},
                    label: const Text("Finish Task")
                  ),
                ),
              ],
            )
        )
    );
  }
}
