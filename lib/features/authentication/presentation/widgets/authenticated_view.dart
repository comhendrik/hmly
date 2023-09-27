import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/LogoutButton.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/account_view.dart';
import 'package:household_organizer/features/charts/presentation/pages/chart_page.dart';
import 'package:household_organizer/features/household/presentation/pages/household_page.dart';

class AuthenticatedView extends StatefulWidget {
  final User mainUser;
  const AuthenticatedView({super.key, required this.mainUser});


  @override
  State<AuthenticatedView> createState() => _AuthenticatedView();
}

class _AuthenticatedView extends State<AuthenticatedView> {

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
        ],
      ),
      body: <Widget>[
        Container(
          alignment: Alignment.center,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                "Welcome back ${widget.mainUser.name}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              HouseholdPage(mainUser: widget.mainUser,),

            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ChartPage(mainUser: widget.mainUser),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              AccountView(mainUser: widget.mainUser),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const LogoutButton(),
                  ElevatedButton(onPressed: () {
                    deleteAuthDataFromHousehold(widget.mainUser);
                  },
                      child: const Text("Change household")
                  )
                ],
              )
            ],
          ),
        ),
      ][currentPageIndex],
    );

  }

  void deleteAuthDataFromHousehold(User user) {
    BlocProvider.of<AuthBloc>(context)
        .add(DeleteAuthDataFromHouseholdEvent(user: user));
  }
}