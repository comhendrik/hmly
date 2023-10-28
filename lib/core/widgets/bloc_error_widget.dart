import 'package:flutter/material.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';

class BlocErrorWidget extends StatelessWidget {
  final Failure failure;
  final Function() reloadAction;


  const BlocErrorWidget({
    super.key,
    required this.failure,
    required this.reloadAction
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(failure.type.title),
          Text(failure.data['code'].toString()),
          Text(failure.data['message']),
          ElevatedButton(onPressed: () {
            reloadAction();
          }, child: const Text("Try again"))
        ],
      ),
    );
  }
}

