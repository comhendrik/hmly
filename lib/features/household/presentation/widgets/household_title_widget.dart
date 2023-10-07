import 'package:flutter/material.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'widget.dart';

class HouseholdTitleWidget extends StatefulWidget {
  final Household household;
  const HouseholdTitleWidget({
    super.key,
    required this.household
  });

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
                      UpdateHouseholdTitle(household: widget.household),
                      BackButton(onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                )
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0)
        ),
        child: Card(
            elevation: 0.125,
            // No elevation for the Card; we'll use the shadow from the Container
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
                        ),
                        child: const Icon(
                          Icons.home,
                          color: Colors.white, // Change the icon color as needed
                          size: 25.0, // Adjust the icon size as needed
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Current Household', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(widget.household.id),
                            Text(widget.household.title),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.black, // Change the icon color as needed
                      size: 25.0, // Adjust the icon size as needed
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
