import 'package:flutter/material.dart';

class HouseholdInformationCard extends StatefulWidget {
  final Function() action;
  final String title;
  final Widget? titleWidget;
  final Widget detailWidget;
  final Icon buttonIcon;
  final String buttonText;
  const HouseholdInformationCard({
    super.key,
    required this.action,
    required this.title,
    required this.titleWidget,
    required this.detailWidget,
    required this.buttonIcon,
    required this.buttonText
  });

  @override
  State<HouseholdInformationCard> createState() => _HouseholdInformationCardState();
}

class _HouseholdInformationCardState extends State<HouseholdInformationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
              ElevatedButton.icon(
                  onPressed: () {
                    widget.action();
                  },
                  icon: widget.buttonIcon,
                  label: Text(widget.buttonText),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          widget.detailWidget,
        ],
      ),
    );

  }
}
