import 'package:flutter/material.dart';

class BlocErrorWidget extends StatelessWidget {
  final String errorMsg;
  final void reloadAction;


  const BlocErrorWidget({
    super.key,
    required this.errorMsg,
    required this.reloadAction
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(errorMsg),
          ElevatedButton(onPressed: () {
            reloadAction;
          }, child: const Text("Try again"))
        ],
      ),
    );
  }
}

