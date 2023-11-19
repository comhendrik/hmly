import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import '../widgets/widget.dart';
import 'package:flutter_share/flutter_share.dart';
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
  String titleStr = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userIDFromNewAdmin = "";
  List<bool> isSelected = [];
  List<User> selectedUser = [];
  final double heightForSheetSizedBox = 10;

  @override
  void initState() {
    titleController.text = widget.household.title;
    super.initState();

    //init list of tuples for users
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          HouseholdInformationCard(
            title: "Household Title",
            titleWidget:
            widget.mainUser.id == widget.household.admin.id ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Current:"),
                  Text(widget.household.title)
                ],
              ) : null ,
            detailWidget:
            widget.mainUser.id == widget.household.admin.id ?
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  titleStr = titleController.text;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.validatorMessageNull;
                  }
                  if (value == widget.household.title) {
                    return "Title can't be the same";
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
                  if (_formKey.currentState!.validate()) {
                    updateHouseholdTitle(widget.household.id, titleStr);
                  }
                },
                buttonIcon: const Icon(Icons.update),
                buttonText: 'Update',
              ) : null,
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
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.admin_panel_settings, weight: 5.0),
                                            Text(' Change Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
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
                                              label: const Text('Cancel')
                                          ),
                                          ElevatedButton(
                                            onPressed: userIDFromNewAdmin == "" ? null : ()  => showDialog<String>(
                                              context: context,
                                              builder: (BuildContext alertContext) => AlertDialog(
                                                title: const Text('Warning'),
                                                content: Text('Do you really want to give the user with the id $userIDFromNewAdmin your admin rights? \nYou are not able to get them back on your own.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: ()  => Navigator.pop(alertContext, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      updateAdmin(widget.household.id, userIDFromNewAdmin);


                                                      //Pop context of alert
                                                      Navigator.pop(alertContext);

                                                      //Pop context of sheet
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Change', style: TextStyle(color: Colors.red),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            child: const Text("Proceed"),
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
                buttonIcon: const Icon(Icons.admin_panel_settings),
                buttonText: 'Change Admin',
              ) : null,
          ),
          HouseholdInformationCard(
              title: "Household Id",
              titleWidget: null,
              detailWidget: Text(widget.household.id),
              button: HouseholdInformationCardButton(
                action: () {
                  Clipboard.setData(ClipboardData(text: widget.household.id))
                      .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied ID: '${widget.household.id}'"))));
                },
                buttonIcon: const Icon(Icons.save),
                buttonText: 'Copy ID',
              ),
          ),
          HouseholdInformationCard(
              title: "User",
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
                                  title: const Text('Delete Warning'),
                                  content: const Text('Do you really want to remove this user?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: ()  => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteAuthDataFromHousehold(user.id, widget.household);
                                        Navigator.pop(context, 'Remove');
                                      },
                                      child: const Text('Remove', style: TextStyle(color: Colors.red),),
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
              button: HouseholdInformationCardButton(
                action: () async {
                  //TODO: Create real link
                  const host = '127.0.0.1';
                  await FlutterShare.share(
                      title: 'Invite Link',
                      text: "I wanted to invite you to my household. Use this ID '${widget.household.id}' to join my household",
                      linkUrl: 'https://$host.com/${widget.household.id}'
                  );
                },
                buttonIcon: const Icon(Icons.person_add),
                buttonText: 'Invite User',
              ),
          ),
          HouseholdInformationCard(
              title: "Household",
              titleWidget: null,
              detailWidget: const Text("Click to leave household"),
              button: HouseholdInformationCardButton(
                action: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(widget.mainUser.id == widget.household.admin.id ? 'Admin Warning' : 'Warning'),
                    content: Text(
                        widget.mainUser.id == widget.household.admin.id ?
                        (widget.household.users.length == 1 ? 'When u leave the household as an admin. The household will be deleted!' : 'You can only leave the household as an admin, when u are the only user in this household') :
                        'When pressing okay, you will leave the household'
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: ()  => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
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
                          child: const Text('Leave', style: TextStyle(color: Colors.red),),
                        ),
                    ],
                  ),
                ),
                buttonIcon: const Icon(Icons.arrow_back),
                buttonText: 'Leave',
              ))
        ],
      )
    );
  }

  void updateHouseholdTitle(String householdID, String householdTitle) {
    BlocProvider.of<HouseholdBloc>(widget.context)
        .add(UpdateHouseholdTitleEvent(householdID: householdID, householdTitle: householdTitle));
  }

  void deleteAuthDataFromHousehold(String userID, Household household) {
    BlocProvider.of<HouseholdBloc>(widget.context)
      .add(DeleteAuthDataFromHouseholdEvent(userID: userID, household: household));

  }

  void updateAdmin(String householdID, String userID) {
    BlocProvider.of<HouseholdBloc>(widget.context)
        .add(UpdateAdminEvent(householdID: householdID, userID: userID));
  }

  void leaveHousehold(User user) {
    BlocProvider.of<AuthBloc>(widget.context)
        .add(LeaveHouseholdEvent(user: user));
  }

  void deleteHousehold(String householdID) {
    BlocProvider.of<HouseholdBloc>(widget.context)
        .add(DeleteHouseholdEvent(householdID: householdID));
  }

}
