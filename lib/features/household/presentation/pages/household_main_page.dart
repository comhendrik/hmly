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
  final User mainUser;
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

  final titleController = TextEditingController();
  final userIDController = TextEditingController();
  String titleStr = "";
  final GlobalKey<FormState> _titleFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _IDFormKey = GlobalKey<FormState>();
  String userIDFromNewAdmin = "";
  List<bool> isSelected = [];
  List<User> selectedUser = [];
  final double heightForSheetSizedBox = 10;

  @override
  void initState() {
    titleController.text = widget.household.title;
    super.initState();

    //init list of tuples for users, this for getting the picker when wanting to change admin, initialized
    isSelected = List<bool>.filled(widget.household.users.length - 1 , false, growable: false);
    for (int i = 0; i < widget.household.users.length; i++) {
      final iteratedUser = widget.household.users[i];
      if (iteratedUser.id != widget.household.admin.id) {
        selectedUser.add(iteratedUser);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _titleFormKey,
          child: HouseholdInformationCard(
            title: AppLocalizations.of(context)!.title,
            titleWidget:
            widget.mainUser.id == widget.household.admin.id ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.current),
                Text(widget.household.title)
              ],
            ) : null ,
            detailWidget:
            widget.mainUser.id == widget.household.admin.id ?
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.institutionTitleHint,
                prefixIcon: const Icon(Icons.home),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                titleStr = titleController.text;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.validatorMessageNull;
                }
                if (value == widget.household.title) {
                  return AppLocalizations.of(context)!.validatorMessageSame;
                }
                if (value.length >= 15) {
                  return AppLocalizations.of(context)!.titleValidatorMessageLength;
                }
                return null;
              },
            ) : Text(widget.household.title),
            button:
            widget.mainUser.id == widget.household.admin.id ?
            HouseholdInformationCardButton(
              action: () {
                if (_titleFormKey.currentState!.validate()) {
                  updateHouseholdTitle(widget.household, titleStr);
                }
              },
              buttonIcon: Icons.update,
              buttonText: AppLocalizations.of(context)!.update,
            ) : null,
          ),
        ),
        HouseholdInformationCard(
          title: AppLocalizations.of(context)!.admin,
          titleWidget: null,
          detailWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppLocalizations.of(context)!.username}: ${widget.household.admin.username}'),
              Text('${AppLocalizations.of(context)!.shortIdentifier}: ${widget.household.admin.id}'),
            ],
          ),
          button:
          widget.mainUser.id == widget.household.admin.id ?
          HouseholdInformationCardButton(
            action: () => showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (context, setState) {
                      var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                      return AnimatedPadding(
                        padding: EdgeInsets.only(bottom: keyboardHeight),
                        duration: const Duration(milliseconds: 20),
                        child: SafeArea(
                            bottom: keyboardHeight <= 0.0,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(height: heightForSheetSizedBox,),
                                  // Row for Headline
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.admin_panel_settings, weight: 5.0),
                                        Text(AppLocalizations.of(context)!.changeAdmin, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: heightForSheetSizedBox,),
                                  ToggleButtons(
                                    isSelected: isSelected,
                                    onPressed: (int index) {
                                      userIDFromNewAdmin = selectedUser[index].id;
                                      setState(() {
                                        for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                                          if (buttonIndex == index) {
                                            isSelected[buttonIndex] =
                                            !isSelected[buttonIndex];
                                          } else {
                                            isSelected[buttonIndex] = false;
                                          }
                                        }
                                      });

                                    },
                                    children:  <Widget>[
                                      for (User user in widget.household.users)
                                        if (user.id != widget.household.admin.id)
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(user.name),
                                          )
                                    ],
                                  ),
                                  SizedBox(height: heightForSheetSizedBox,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      //Not custom, because it is a cancel button
                                      ElevatedButton.icon(
                                          icon: const Icon(Icons.cancel),
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15)
                                              )
                                          ),

                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          label: Text(AppLocalizations.of(context)!.cancel)
                                      ),
                                      CustomElevatedButton(
                                          buttonText: AppLocalizations.of(context)!.proceed,
                                          action: userIDFromNewAdmin == "" ? null : ()  => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext alertContext) => AlertDialog(
                                              title: Text(AppLocalizations.of(context)!.warning),
                                              content: Text(AppLocalizations.of(context)!.changeAdminWarningMessage(userIDFromNewAdmin)),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: ()  => Navigator.pop(alertContext, 'Cancel'),
                                                  child: Text(AppLocalizations.of(context)!.cancel),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    updateAdmin(widget.household.id, userIDFromNewAdmin);


                                                    //Pop context of alert
                                                    Navigator.pop(alertContext);

                                                    //Pop context of sheet
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(AppLocalizations.of(context)!.change, style: const TextStyle(color: Colors.red),),
                                                ),
                                              ],
                                            ),
                                          ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                      );
                    }
                );
              },
            ),
            buttonIcon: Icons.admin_panel_settings,
            buttonText: AppLocalizations.of(context)!.changeAdmin,
          ) : null,
        ),
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
                for (User user in widget.household.users)
                  Row(
                    children: [
                      Text(user.name),
                      if (user.id != widget.mainUser.id && widget.mainUser.id == widget.household.admin.id)
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
                        if (widget.mainUser.id == widget.household.admin.id && id != widget.mainUser.id)
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
                if (widget.mainUser.id == widget.household.admin.id)
                  TextFormField(
                    controller: userIDController,
                    decoration: InputDecoration(
                      //TODO: Change hint text
                      hintText: AppLocalizations.of(context)!.user,
                      prefixIcon: const Icon(Icons.verified_user),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.length != 15) {
                        return AppLocalizations.of(context)!.identifierValidatorMessage;
                      }
                      return null;
                    },
                  ),
              ],
            ),
            button: widget.mainUser.id == widget.household.admin.id ? HouseholdInformationCardButton(
              action: () {
                if (_IDFormKey.currentState!.validate()) {
                  updateAllowedUsers(userIDController.text, widget.household, false);
                }
              },
              buttonIcon: Icons.add,
              buttonText: AppLocalizations.of(context)!.identifier,
            ) : null,
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
                      widget.mainUser.id == widget.household.admin.id ?
                      (widget.household.users.length == 1 ? AppLocalizations.of(context)!.leaveInstitutionHintAdmin : AppLocalizations.of(context)!.leaveInstitutionHintAdminUser) :
                      AppLocalizations.of(context)!.leaveInstitutionHint
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: ()  => Navigator.pop(context, 'Cancel'),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    if (widget.household.admin.id != widget.mainUser.id || widget.household.users.length == 1)
                      TextButton(
                        onPressed: () {
                          if (widget.mainUser.id == widget.household.admin.id || widget.household.users.length == 1) {
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

  void updateHouseholdTitle(Household household, String householdTitle) {
    BlocProvider.of<HouseholdBloc>(widget.context)
        .add(UpdateHouseholdTitleEvent(household: household, householdTitle: householdTitle, context: widget.context));
  }

  void deleteAuthDataFromHousehold(String userID, Household household) {
    BlocProvider.of<HouseholdBloc>(widget.context)
      .add(DeleteAuthDataFromHouseholdEvent(userID: userID, household: household, context: widget.context));

  }

  void updateAdmin(String householdID, String userID) {
    BlocProvider.of<HouseholdBloc>(widget.context)
        .add(UpdateAdminEvent(householdID: householdID, userID: userID, context: widget.context));
  }

  void leaveHousehold(User user) {
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
