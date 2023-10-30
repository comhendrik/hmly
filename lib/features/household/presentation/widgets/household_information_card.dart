import 'package:flutter/material.dart';

class HouseholdInformationCardButton {
  final Function() action;
  final Icon buttonIcon;
  final String buttonText;

  const HouseholdInformationCardButton({
    required this.action,
    required this.buttonIcon,
    required this.buttonText
  });
}

class HouseholdInformationCard extends StatefulWidget {
  final String title;
  final Widget? titleWidget;
  final Widget detailWidget;
  final HouseholdInformationCardButton? button;

  const HouseholdInformationCard({
    super.key,
    required this.title,
    required this.titleWidget,
    required this.detailWidget,
    required this.button
  });

  @override
  State<HouseholdInformationCard> createState() => _HouseholdInformationCardState();
}

class _HouseholdInformationCardState extends State<HouseholdInformationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        elevation: 0.125,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold),),
                    if (widget.titleWidget != null)
                      widget.titleWidget!,
                  ],
                ),
                if(widget.button != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      widget.button!.action();
                    },
                    icon: widget.button!.buttonIcon,
                    label: Text(widget.button!.buttonText),
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            widget.detailWidget,
          ],
        ),
      )
    );

  }
}
