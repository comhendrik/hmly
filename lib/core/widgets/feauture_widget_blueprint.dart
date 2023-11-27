import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class FeatureWidgetBlueprint extends StatefulWidget {

  final String title;
  final IconData? titleIcon;
  final Function()? reloadAction;
  final Widget widget;
  final Widget? extraWidget;

  const FeatureWidgetBlueprint({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.reloadAction,
    required this.widget,
    this.extraWidget
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
          children: [
            if (widget.titleIcon == null)
              Image.asset('assets/png/logo-no-background.png', height: 50, width: 50,),
            if (widget.titleIcon != null)
              Icon(widget.titleIcon, weight: 5.0),
            Text(' ${widget.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            const Spacer(),
            if (widget.extraWidget != null)
              widget.extraWidget!,
            if(widget.reloadAction != null)
              IconButton(onPressed: widget.reloadAction, icon: const Icon(Icons.update)),

          ],
        ),
        widget.widget,

      ],
    );
  }
}
