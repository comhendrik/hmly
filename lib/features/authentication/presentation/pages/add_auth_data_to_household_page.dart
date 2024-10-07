import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/custom_button.dart';
import 'package:hmly/core/widgets/feauture_widget_blueprint.dart';
import 'package:hmly/features/authentication/presentation/bloc/auth_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAuthDataToHouseholdPage extends StatefulWidget {
  final UserData mainUser;

  const AddAuthDataToHouseholdPage({super.key, required this.mainUser});


  @override
  State<AddAuthDataToHouseholdPage> createState() => _AddAuthDataToHouseholdPage();
}

class _AddAuthDataToHouseholdPage extends State<AddAuthDataToHouseholdPage> {

  final householdIDController = TextEditingController();
  String householdIDStr = '';
  final _idFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FeatureWidgetBlueprint(
        title: AppLocalizations.of(context)!.institutionTitle,
        titleIcon: Icons.house,
        reloadAction: null,
        widget: Column(
          children: [
            Form(
              key: _idFormKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.joinInstitution),
                        ],
                      ),
                      TextFormField(
                          controller: householdIDController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.institutionIdentifier,
                            hintText: AppLocalizations.of(context)!.institutionIdentifierHint,
                            prefixIcon: const Icon(Icons.person), // Icon for username
                          ),
                          validator: (value) {
                            if (value == null) {
                              return AppLocalizations.of(context)!.identifierValidatorMessage;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            householdIDStr = value;
                          }
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomIconElevatedButton(
                            icon: Icons.arrow_forward,
                            buttonText: AppLocalizations.of(context)!.join,
                            action: () {
                              if (_idFormKey.currentState!.validate()) {
                                addAuthDataToHousehold(widget.mainUser, householdIDStr, context);
                              }
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.createInstitution),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomIconElevatedButton(
                          icon: Icons.arrow_forward,
                          buttonText: AppLocalizations.of(context)!.create,
                          action: () {
                            createHouseholdAndAddAuthData(widget.mainUser, context);
                          }
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }

  void addAuthDataToHousehold(UserData user, String householdID, BuildContext bContext) {
    BlocProvider.of<AuthBloc>(bContext)
        .add(AddAuthDataToHouseholdEvent(user: user, householdID: householdID, context: bContext));
  }

  void createHouseholdAndAddAuthData(UserData user, BuildContext bContext) {
    BlocProvider.of<AuthBloc>(context)
        .add(CreateHouseholdAndAddAuthDataEvent(user: user, context: bContext));
  }
}