import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/feauture_widget_blueprint.dart';
import 'package:hmly/features/authentication/presentation/bloc/auth_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAuthDataToHouseholdPage extends StatefulWidget {
  final User mainUser;

  const AddAuthDataToHouseholdPage({super.key, required this.mainUser});


  @override
  State<AddAuthDataToHouseholdPage> createState() => _AddAuthDataToHouseholdPage();
}

class _AddAuthDataToHouseholdPage extends State<AddAuthDataToHouseholdPage> {

  final householdIDController = TextEditingController();
  final householdTitleController = TextEditingController();
  String householdIDStr = '';
  String householdTitleStr = '';
  final _idFormKey = GlobalKey<FormState>();
  final _titleFormKey = GlobalKey<FormState>();

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
                            if (value == null || value.length != 15) {
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
                        child: ElevatedButton.icon(
                            onPressed: () {
                              if (_idFormKey.currentState!.validate()) {
                                addAuthDataToHousehold(widget.mainUser, householdIDStr);
                              }
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: Text(AppLocalizations.of(context)!.join)
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           Text(AppLocalizations.of(context)!.createInstitution),
                        ],
                      ),
                      TextFormField(
                          controller: householdTitleController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.institutionTitleField,
                            hintText: AppLocalizations.of(context)!.institutionTitleHint,
                            prefixIcon: const Icon(Icons.person), // Icon for username
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.validatorMessageNull;
                            }
                            if (value.length >= 15) {
                              return AppLocalizations.of(context)!.titleValidatorMessageLength;
                            }
                            return null;
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
                              createHouseholdAndAddAuthData(widget.mainUser, householdTitleStr);
                            }
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: Text(AppLocalizations.of(context)!.create),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
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