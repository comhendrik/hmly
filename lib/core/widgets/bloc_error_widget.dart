import 'package:flutter/material.dart';
import 'package:hmly/core/error/failure.dart';

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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error, // Error icon
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              failure.type.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Error Code: ${failure.data['code'].toString()}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              failure.data['message'],
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: reloadAction,
              child: const Row(
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
      ),
    );
  }
}

