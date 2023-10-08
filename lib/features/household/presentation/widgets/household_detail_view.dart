import 'package:flutter/material.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/presentation/widgets/household_information_widget.dart';

class HouseholdDetailView extends StatefulWidget {
  final Household household;
  final BuildContext context;

  const HouseholdDetailView({
    super.key,
    required this.household,
    required this.context
  });

  @override
  State<HouseholdDetailView> createState() => _HouseholdDetailViewState();
}

class _HouseholdDetailViewState extends State<HouseholdDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: false,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          bottom: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, weight: 30.0)
                      ),
                      const Icon(Icons.house, weight: 5.0),
                      const Text(' Household', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      HouseholdInformationWidget(context: widget.context, household: widget.household),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
