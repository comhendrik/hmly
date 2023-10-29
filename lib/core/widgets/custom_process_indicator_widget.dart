import 'dart:async';

import 'package:flutter/material.dart';

class CustomProcessIndicator extends StatefulWidget {
  final Function() reloadAction;
  final String msg;

  const CustomProcessIndicator({
    super.key,
    required this.reloadAction,
    required this.msg
  });

  @override
  State<CustomProcessIndicator> createState() => _CustomProcessIndicatorState();
}

class _CustomProcessIndicatorState extends State<CustomProcessIndicator> {

  bool showRetryButton = false;
  Timer? _delationTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 1. Using Timer
    _delationTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        showRetryButton = true;
      });
    });
  }

  @override
  void dispose() {
    _delationTimer?.cancel();
    _delationTimer = null;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            widget.msg,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          if (showRetryButton)
            ElevatedButton(
              onPressed: widget.reloadAction,
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
    );
  }
}


