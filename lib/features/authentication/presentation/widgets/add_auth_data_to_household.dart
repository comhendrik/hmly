import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/LogoutButton.dart';

class AddAuthDataToHouseholdView extends StatefulWidget {
  final User user;

  const AddAuthDataToHouseholdView({super.key, required this.user});


  @override
  State<AddAuthDataToHouseholdView> createState() => _AddAuthDataToHouseholdView();
}

class _AddAuthDataToHouseholdView extends State<AddAuthDataToHouseholdView> {

  final householdIDController = TextEditingController();
  final householdTitleController = TextEditingController();
  String householdIDStr = '';
  String householdTitleStr = '';
  final _idFormKey = GlobalKey<FormState>();
  final _titleFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.house, weight: 5.0),
            Text(' Add user to household!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
          ],
        ),
        Form(
          key: _idFormKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  const Text('Join an existing one:'),
                  TextFormField(
                      controller: householdIDController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Household Id',
                        hintText: 'Enter an ID from an household',
                        prefixIcon: Icon(Icons.person), // Icon for username
                      ),
                      validator: (value) {
                        if (value == null || value.length != 15) {
                          return 'The length must be exactly 15.';
                        }
                      },
                      onChanged: (value) {
                        householdIDStr = value;
                      }
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          if (_idFormKey.currentState!.validate()) {
                            addAuthDataToHousehold(widget.user, householdIDStr);
                          }
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Add")
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Form(
          key: _titleFormKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  const Text('Or create a new one'),
                  TextFormField(
                      controller: householdTitleController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Household Title',
                        hintText: 'Enter a ID from an household',
                        prefixIcon: Icon(Icons.person), // Icon for username
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a title';
                        }
                        if (value.length >= 15) {
                          return 'Must be less than 15 characters';
                        }
                      },
                      onChanged: (value) {
                        householdTitleStr = value;
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_titleFormKey.currentState!.validate()) {
                          createHouseholdAndAddAuthData(widget.user, householdTitleStr);
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Create"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const LogoutButton(),
      ],
    );
  }

  void addAuthDataToHousehold(User user, String householdID) {
    BlocProvider.of<AuthBloc>(context)
        .add(AddAuthDataToHouseholdEvent(user: user, householdID: householdID));
  }

  void createHouseholdAndAddAuthData(User user, String householdTitle) {
    BlocProvider.of<AuthBloc>(context)
        .add(CreateHouseholdAndAddAuthDataEvent(user: user, householdTitle: householdTitle));
  }
}