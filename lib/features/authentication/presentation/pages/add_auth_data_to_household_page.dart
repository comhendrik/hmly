import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/custom_button.dart';
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
                        child: CustomIconElevatedButton(
                            icon: Icons.arrow_forward,
                            buttonText: AppLocalizations.of(context)!.create,
                            action: () {
                              if (_titleFormKey.currentState!.validate()) {
                                createHouseholdAndAddAuthData(widget.mainUser, householdTitleStr, context);
                              }
                            }
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

  void addAuthDataToHousehold(User user, String householdID, BuildContext bContext) {
    BlocProvider.of<AuthBloc>(bContext)
        .add(AddAuthDataToHouseholdEvent(user: user, householdID: householdID, context: bContext));
  }

  void createHouseholdAndAddAuthData(User user, String householdTitle, BuildContext bContext) {
    BlocProvider.of<AuthBloc>(context)
        .add(CreateHouseholdAndAddAuthDataEvent(user: user, householdTitle: householdTitle, context: bContext));
  }
}