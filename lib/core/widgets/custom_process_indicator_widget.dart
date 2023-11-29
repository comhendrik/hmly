import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
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
    super.initState();
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
          const CupertinoActivityIndicator(),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.refresh), // Retry icon
                  const SizedBox(width: 8),
                  Text(
                      AppLocalizations.of(context)!.reload,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


