import 'package:flutter/material.dart';

class FeatureWidgetBlueprint extends StatefulWidget {

  final String title;
  final IconData titleIcon;
  final Function() reloadAction;
  final Widget widget;

  const FeatureWidgetBlueprint({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.reloadAction,
    required this.widget
  });

  @override
  State<FeatureWidgetBlueprint> createState() => _FeatureWidgetBlueprintState();
}

class _FeatureWidgetBlueprintState extends State<FeatureWidgetBlueprint> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.titleIcon, weight: 5.0),
            Text(' ${widget.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            IconButton(onPressed: widget.reloadAction, icon: const Icon(Icons.update))
          ],
        ),
        widget.widget,
      ],
    );
  }
}
