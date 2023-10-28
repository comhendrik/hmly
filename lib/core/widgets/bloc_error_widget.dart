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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error, // Error icon
            size: 64,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            failure.type.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Error Code: ${failure.data['code'].toString()}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            failure.data['message'],
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: reloadAction,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.refresh), // Retry icon
                SizedBox(width: 8),
                Text(
                  'Retry',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

