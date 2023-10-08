import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/presentation/widgets/household_detail_view.dart';

class HouseholdWidget extends StatefulWidget {
  final Household household;
  final User mainUser;
  final BuildContext context;
  const HouseholdWidget({
    super.key,
    required this.household,
    required this.mainUser,
    required this.context
  });

  @override
  State<HouseholdWidget> createState() => _HouseholdWidgetState();
}

class _HouseholdWidgetState extends State<HouseholdWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HouseholdDetailView(context: widget.context, household: widget.household)
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
              padding: const EdgeInsets.all(5.0),
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
