import 'package:flutter/material.dart';

class CustomProcessIndicator extends StatelessWidget {
  final Function() reloadAction;


  const CustomProcessIndicator({
    super.key,
    required this.reloadAction
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
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
