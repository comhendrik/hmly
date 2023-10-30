import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/presentation/pages/account_page.dart';
import 'package:household_organizer/features/charts/presentation/pages/chart_page.dart';
import 'package:household_organizer/features/household/presentation/pages/household_page.dart';
import 'package:household_organizer/features/household_task/presentation/pages/household_task_page.dart';

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
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.task),
            icon: Icon(Icons.task_outlined),
            label: 'Tasks',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.insert_chart),
            icon: Icon(Icons.insert_chart_outlined),
            label: 'Statistics',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.house),
            icon: Icon(Icons.house_outlined),
            label: 'Household',
          ),
        ],
      ),
      body: <Widget>[
        _buildNavigationDestination(widget: HouseholdTaskPage(mainUser: widget.mainUser)),
        _buildNavigationDestination(widget: ChartPage(mainUser: widget.mainUser)),
        _buildNavigationDestination(widget: AccountPage(mainUser: widget.mainUser, ancestorContext: context)),
        _buildNavigationDestination(widget: HouseholdPage(mainUser: widget.mainUser))
      ][currentPageIndex],
    );
  }

  Widget _buildNavigationDestination({
    required Widget widget,
  }) {
    return Container(
      alignment: Alignment.center,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          widget
        ],
      ),
    );
  }

}