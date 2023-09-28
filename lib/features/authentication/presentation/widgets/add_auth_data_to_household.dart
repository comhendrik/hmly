import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/LogoutButton.dart';

//TODO: Maybe make one widget for login signup and adding to household and make it dynamic, idea because they look similar and use DRY

class AddAuthDataToHouseholdView extends StatefulWidget {
  final User user;

  const AddAuthDataToHouseholdView({super.key, required this.user});


  @override
  State<AddAuthDataToHouseholdView> createState() => _AddAuthDataToHouseholdView();
}

class _AddAuthDataToHouseholdView extends State<AddAuthDataToHouseholdView> {

  final householdIdController = TextEditingController();
  String householdIdStr = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.house, weight: 5.0),
                  Text(' Add user to household!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                ],
              ),
              TextFormField(
                  controller: householdIdController,
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
                    householdIdStr = value;
                  }
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addAuthDataToHousehold(widget.user, householdIdStr);
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Add user to household")
              ),
              const LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  void addAuthDataToHousehold(User user, String householdId) {
    BlocProvider.of<AuthBloc>(context)
        .add(AddAuthDataToHouseholdEvent(user: user, householdId: householdId));
  }

}