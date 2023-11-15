import 'package:flutter/material.dart';

Widget buildNavigationDestination({
  required Widget widget,
}) {
  return Container(
    alignment: Alignment.center,
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        widget
      ],
    ),
  );
}