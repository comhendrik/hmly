import 'package:flutter/material.dart';
import 'widget.dart';

class HouseholdTitleWidget extends StatefulWidget {
  const HouseholdTitleWidget({super.key});

  @override
  State<HouseholdTitleWidget> createState() => _HouseholdTitleWidgetState();
}

class _HouseholdTitleWidgetState extends State<HouseholdTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
                primary: false,
                resizeToAvoidBottomInset: true,
                body: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      HouseholdPage(mainUser: widget.mainUser),
                      BackButton(onPressed: () {
                        Navigator.pop(context);
                      },)
                    ],
                  ),
                )
            ),
          ),
        );
      },
      child: _buildListTile(
          leadingIcon: Icons.home,
          title: 'Current Household',
          subtitle: widget.mainUser.householdId,
          trailingIcon: Icons.arrow_forward
      ),
    );
  }
}
