import 'package:flutter/material.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/build_navigation_destination.dart';
import 'package:hmly/features/authentication/presentation/pages/account_page.dart';
import 'package:hmly/features/authentication/presentation/pages/add_auth_data_to_household_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthMainPageWithoutHousehold extends StatefulWidget {
  
  final User mainUser;
  const AuthMainPageWithoutHousehold({
    super.key,
    required this.mainUser
  });

  @override
  State<AuthMainPageWithoutHousehold> createState() => _AuthMainPageWithoutHouseholdState();
}

class _AuthMainPageWithoutHouseholdState extends State<AuthMainPageWithoutHousehold> {
  
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.house),
            icon: const Icon(Icons.house_outlined),
            label: AppLocalizations.of(context)!.institutionTitle,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.person),
            icon: const Icon(Icons.person_outline),
            label: AppLocalizations.of(context)!.accountInformation,
          ),
        ],
      ),
      body: <Widget>[
        buildNavigationDestination(widget: AddAuthDataToHouseholdPage(mainUser: widget.mainUser)),
        buildNavigationDestination(widget: AccountPage(mainUser: widget.mainUser, ancestorContext: context)),
      ][currentPageIndex],
    );
  }
}
