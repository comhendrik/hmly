import 'package:flutter/material.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/presentation/widgets/update_title_widget.dart';

class HouseholdDetailView extends StatefulWidget {
  final Household household;

  const HouseholdDetailView({
    super.key,
    required this.household
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
          child: Column(
            children: [
              UpdateHouseholdTitle(household: widget.household),
              BackButton(onPressed: () {
                Navigator.pop(context);
              },
              ),
            ],
          ),
        )
    );
  }
}
