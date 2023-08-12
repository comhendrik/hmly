import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/presentation/pages/auth_page.dart';
import 'package:household_organizer/features/household/presentation/pages/household_page.dart';
import 'package:household_organizer/features/household_task/presentation/pages/household_task_page.dart';
import 'features/authentication/presentation/widgets/LogoutButton.dart';

class HouseholdHome extends StatefulWidget {

  const HouseholdHome({super.key});


  @override
  State<HouseholdHome> createState() => _HouseholdHomeState();
}

class _HouseholdHomeState extends State<HouseholdHome> {

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      primary: false,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: AuthPage(),
      )
    );
  }
}

