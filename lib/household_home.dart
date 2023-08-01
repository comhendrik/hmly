import 'package:flutter/material.dart';
import 'package:household_organizer/features/authentication/presentation/pages/auth_page.dart';
import 'package:household_organizer/features/household/presentation/pages/household_page.dart';
import 'package:household_organizer/features/household_task/presentation/pages/household_task_page.dart';
import 'test_secure_storage.dart';

class HouseholdHome extends StatefulWidget {
  final String householdName;
  const HouseholdHome({super.key, required this.householdName});


  @override
  State<HouseholdHome> createState() => _HouseholdHomeState();
}

class _HouseholdHomeState extends State<HouseholdHome> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      primary: false,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                widget.householdName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const HouseholdTaskPage(),
              const HouseholdPage(),

              //Only for testing purposes
              const SControls(),
              const AuthPage(),
            ],
          )
      )
    );
  }
}