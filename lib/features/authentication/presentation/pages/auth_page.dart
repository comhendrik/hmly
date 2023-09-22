import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/domain/usecases/delete_auth_data_from_household.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:household_organizer/features/charts/presentation/pages/chart_page.dart';
import 'package:household_organizer/features/charts/presentation/widgets/bar_chart.dart';
import 'package:household_organizer/features/charts/presentation/widgets/pie_chart.dart';
import 'package:household_organizer/features/household/presentation/pages/household_page.dart';
import 'package:household_organizer/features/household/presentation/widgets/pie_chart.dart';
import 'package:household_organizer/features/household_task/presentation/pages/household_task_page.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/LogoutButton.dart';


import '../../../../injection_container.dart';

class AuthPage extends StatelessWidget {

  const AuthPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<AuthBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            BlocProvider.of<AuthBloc>(context)
                .add(LoadAuthEvent());
            return const Text("Data is loading...");
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthLoaded) {
            return state.authData.householdId == "" ? AddAuthDataToHouseholdView(user: state.authData) : AuthenticatedView(mainUser: state.authData);
          } else if (state is AuthError) {
            return Text(state.errorMsg);
          } else if (state is AuthCreate){
            return const AuthenticationWidget();
          } else {
            return const Text("...");
          }
        },
      ),
    );
  }
}


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
        indicatorColor: Colors.lightBlueAccent,
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
                      child: const Text("Delete user from Household")
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

class AddAuthDataToHouseholdView extends StatefulWidget {
  final User user;

  const AddAuthDataToHouseholdView({super.key, required this.user});


  @override
  State<AddAuthDataToHouseholdView> createState() => _AddAuthDataToHouseholdView();
}

class _AddAuthDataToHouseholdView extends State<AddAuthDataToHouseholdView> {

  final householdIdController = TextEditingController();
  String householdIdStr = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Add yourself to household"),
          TextField(
              controller: householdIdController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: 'insert id of household',
                  contentPadding: EdgeInsets.all(20)
              ),
              onChanged: (value) {
                householdIdStr = value;
              }
          ),
          ElevatedButton(onPressed: () {
            addAuthDataToHousehold(widget.user, householdIdStr);
          }, child: const Text("Add user to household")
          ),
          const LogoutButton(),
        ],
      ),
    );
  }

  void addAuthDataToHousehold(User user, String householdId) {
    BlocProvider.of<AuthBloc>(context)
        .add(AddAuthDataToHouseholdEvent(user: user, householdId: householdId));
  }

}