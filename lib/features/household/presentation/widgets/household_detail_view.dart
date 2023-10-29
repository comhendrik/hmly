import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/presentation/pages/household_main_page.dart';

class HouseholdDetailView extends StatefulWidget {
  final Household household;
  final BuildContext context;
  final User mainUser;

  const HouseholdDetailView({
    super.key,
    required this.household,
    required this.context,
    required this.mainUser
  });

  @override
  State<HouseholdDetailView> createState() => _HouseholdDetailViewState();
}

class _HouseholdDetailViewState extends State<HouseholdDetailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.house, weight: 5.0),
            const Text(' Household', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
          ],
        ),
        HouseholdMainPage(context: widget.context, household: widget.household, mainUser: widget.mainUser,),
      ],
    );
  }
}
