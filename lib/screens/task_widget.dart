import 'package:flutter/material.dart';
import '../model/task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
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
                'Due to ${getCurrentDate(task.date)}',
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
  final Task task;
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
                  getCurrentDate(task.date)
                ),
                const Text(
                  'Assigned to',
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                const Text(
                  'Hendrik Steen'
                )
              ],
            )
        )
    );
  }
}
