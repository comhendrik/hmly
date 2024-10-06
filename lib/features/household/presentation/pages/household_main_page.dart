import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/custom_button.dart';
import 'package:hmly/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:hmly/features/household/domain/entities/household.dart';
import 'package:hmly/features/household/presentation/bloc/household_bloc.dart';
import '../widgets/widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HouseholdMainPage extends StatefulWidget {
  final BuildContext context;
  final Household household;
  final UserData mainUser;
  const HouseholdMainPage({
    super.key,
    required this.context,
    required this.household,
    required this.mainUser
  });

  @override
  State<HouseholdMainPage> createState() => _HouseholdMainPageState();
}

class _HouseholdMainPageState extends State<HouseholdMainPage> {
  final userIDController = TextEditingController();
  String titleStr = "";
  final GlobalKey<FormState> _IDFormKey = GlobalKey<FormState>();
  List<bool> isSelected = [];
  List<UserData> selectedUser = [];
  final double heightForSheetSizedBox = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseholdInformationCard(
          title: AppLocalizations.of(context)!.institutionIdentifier,
          titleWidget: null,
          detailWidget: Text(widget.household.id),
          button: HouseholdInformationCardButton(
            action: () {
              Clipboard.setData(ClipboardData(text: widget.household.id))
                  .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.copyIdentifierMessage(widget.household.id)))));
            },
            buttonIcon: Icons.save,
            buttonText: AppLocalizations.of(context)!.copyIdentifier,
          ),
        ),
        HouseholdInformationCard(
            title: AppLocalizations.of(context)!.user,
            titleWidget: null,
            detailWidget: Column(
              children: [
                for (UserData user in widget.household.users)
                  Row(
                    children: [
                      Text(user.name),
                      IconButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!.warning),
                              content: Text(AppLocalizations.of(context)!.removingUserWarning),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: ()  => Navigator.pop(context, 'Cancel'),
                                  child: Text(AppLocalizations.of(context)!.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteAuthDataFromHousehold(user.id, widget.household);
                                    Navigator.pop(context, 'Remove');
                                  },
                                  child: Text(AppLocalizations.of(context)!.remove, style: const TextStyle(color: Colors.red),),
                                ),
                              ],
                            ),
                          ),
                          icon: const Icon(Icons.delete)
                      )
                    ],
                  )
              ],
            ),
            button: null
        ),
        Form(
          key: _IDFormKey,
          child: HouseholdInformationCard(
            title: AppLocalizations.of(context)!.allowedUserIdentifiers,
            titleWidget: null,
            detailWidget: Wrap(
              children: [
                for (String id in widget.household.allowedUsers)
                    Row(
                      children: [
                        Text(id),
                        IconButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(AppLocalizations.of(context)!.warning),
                                content: Text(AppLocalizations.of(context)!.removingUserWarning),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: ()  => Navigator.pop(context, 'Cancel'),
                                    child: Text(AppLocalizations.of(context)!.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      updateAllowedUsers(id, widget.household, true);
                                      Navigator.pop(context, 'Remove');
                                    },
                                    child: Text(AppLocalizations.of(context)!.remove, style: const TextStyle(color: Colors.red),),
                                  ),
                                ],
                              ),
                            ),
                            icon: const Icon(Icons.delete)
                        )
                      ],
                    ),
                TextFormField(
                  controller: userIDController,
                  decoration: InputDecoration(
                    //TODO: Change hint text
                    hintText: AppLocalizations.of(context)!.user,
                    prefixIcon: const Icon(Icons.verified_user),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return AppLocalizations.of(context)!.identifierValidatorMessage;
                    }
                    return null;
                  },
                ),

              ],
            ),
            button: HouseholdInformationCardButton(
              action: () {
                if (_IDFormKey.currentState!.validate()) {
                  updateAllowedUsers(userIDController.text, widget.household, false);
                }
              },
              buttonIcon: Icons.add,
              buttonText: AppLocalizations.of(context)!.identifier,
            )
          ),
        ),
        HouseholdInformationCard(
            title: AppLocalizations.of(context)!.institutionTitle,
            titleWidget: null,
            detailWidget: Text(AppLocalizations.of(context)!.clickToLeaveInstitution),
            button: HouseholdInformationCardButton(
              action: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.warning),
                  content: Text(
                      AppLocalizations.of(context)!.leaveInstitutionHint
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: ()  => Navigator.pop(context, 'Cancel'),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        leaveHousehold(widget.mainUser);
                        if (widget.household.users.length == 1) {
                          leaveHousehold(widget.mainUser);
                          deleteHousehold(widget.household.id);
                        } else {
                          leaveHousehold(widget.mainUser);
                        }
                        Navigator.pop(context, 'Leave');
                      },
                      child: Text(AppLocalizations.of(context)!.leave, style: const TextStyle(color: Colors.red),),
                    ),

                  ],
                ),
              ),
              buttonIcon: Icons.arrow_back,
              buttonText: AppLocalizations.of(context)!.leave,
            )
        )
      ],
    );
  }

  void deleteAuthDataFromHousehold(String userID, Household household) {
    BlocProvider.of<HouseholdBloc>(widget.context)
      .add(DeleteAuthDataFromHouseholdEvent(userID: userID, household: household, context: widget.context));

  }

  void leaveHousehold(UserData user) {
    BlocProvider.of<AuthBloc>(widget.context)
        .add(LeaveHouseholdEvent(user: user, context: widget.context));
  }

  void deleteHousehold(String householdID) {
    BlocProvider.of<HouseholdBloc>(widget.context)
        .add(DeleteHouseholdEvent(householdID: householdID));
  }

  void updateAllowedUsers(String userID, Household household, bool delete) {
    BlocProvider.of<HouseholdBloc>(widget.context)
        .add(UpdateAllowedUsersEvent(userID: userID, household: household, delete: delete, context: widget.context));
  }

}
