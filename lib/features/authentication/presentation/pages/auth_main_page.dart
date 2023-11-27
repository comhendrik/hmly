import 'package:flutter/material.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/build_navigation_destination.dart';
import 'package:hmly/features/authentication/presentation/pages/account_page.dart';
import 'package:hmly/features/charts/presentation/pages/chart_page.dart';
import 'package:hmly/features/household/presentation/pages/household_page.dart';
import 'package:hmly/features/household_task/presentation/pages/household_task_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthMainPage extends StatefulWidget {
  final User mainUser;
  final int startCurrentPageIndex;
  const AuthMainPage({
    super.key,
    required this.mainUser,
    required this.startCurrentPageIndex
  });


  @override
  State<AuthMainPage> createState() => _AuthMainPage();
}

class _AuthMainPage extends State<AuthMainPage> {

  int currentPageIndex = 0;

  @override
  void initState() {
    //Set start index, is needed because you load the view from different points and sometimes you want to show a specific page and not the first
    super.initState();
    currentPageIndex = widget.startCurrentPageIndex;
  }

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
            selectedIcon: const Icon(Icons.task),
            icon: const Icon(Icons.task_outlined),
            label: AppLocalizations.of(context)!.tasksTitle,
          ),

          NavigationDestination(
            selectedIcon: const Icon(Icons.insert_chart),
            icon: const Icon(Icons.insert_chart_outlined),
            label: AppLocalizations.of(context)!.chartsTitle,
          ),

          NavigationDestination(
            selectedIcon: const Icon(Icons.person),
            icon: const Icon(Icons.person_outline),
            label: AppLocalizations.of(context)!.accountInformation,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.house),
            icon: const Icon(Icons.house_outlined),
            label: AppLocalizations.of(context)!.institutionTitle,
          ),
        ],
      ),
      body: <Widget>[
        buildNavigationDestination(widget: HouseholdTaskPage(mainUser: widget.mainUser)),

        buildNavigationDestination(widget: ChartPage(mainUser: widget.mainUser)),

        buildNavigationDestination(widget: AccountPage(mainUser: widget.mainUser, ancestorContext: context)),
        buildNavigationDestination(widget: HouseholdPage(mainUser: widget.mainUser))
      ][currentPageIndex],
    );
  }


}