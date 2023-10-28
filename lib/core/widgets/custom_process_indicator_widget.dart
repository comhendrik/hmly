import 'package:flutter/material.dart';

class CustomProcessIndicator extends StatelessWidget {

  final Function() reloadAction;
  final String msg;

  const CustomProcessIndicator({
    super.key,
    required this.reloadAction,
    required this.msg
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
          Text(msg),
          ElevatedButton.icon(
            onPressed: () {
              reloadAction();
            },
            icon: const Icon(Icons.update),
            label: const  Text("Try again"),
          )
        ],
      ),
    );
  }
}
