import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/widgets/feauture_widget_blueprint.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/change_user_attributes_widget.dart';
import 'package:household_organizer/features/household/presentation/pages/household_page.dart';

class AccountPage extends StatefulWidget {
  final User mainUser;
  final BuildContext ancestorContext;
  const AccountPage({
    super.key,
    required this.mainUser,
    required this.ancestorContext
  });


  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {

  @override
  Widget build(BuildContext context) {
    return FeatureWidgetBlueprint(
        title: "Account Information",
        titleIcon: Icons.person,
        reloadAction: () {
          BlocProvider.of<AuthBloc>(context)
              .add(LoadAuthEvent());
        },
        widget: Column(
          children: [
            GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return ChangeUserAttributesWidget(type: UserChangeType.email, mainUser: widget.mainUser,  ancestorContext: widget.ancestorContext);
                }
              ),
              child: _buildListTile(
                leadingIcon: Icons.email,
                title: 'Email',
                subtitle: widget.mainUser.email,
              ),
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return ChangeUserAttributesWidget(type: UserChangeType.username, mainUser: widget.mainUser, ancestorContext: widget.ancestorContext);
                  }),
              child: _buildListTile(
                leadingIcon: Icons.person,
                title: 'Username',
                subtitle: widget.mainUser.username,
              ),
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return ChangeUserAttributesWidget(type: UserChangeType.name, mainUser: widget.mainUser, ancestorContext: widget.ancestorContext);
                  }),
              child: _buildListTile(
                leadingIcon: Icons.person,
                title: 'Full Name',
                subtitle: widget.mainUser.name,
              ),
            ),
            _buildListTile(
              leadingIcon: Icons.confirmation_number,
              title: 'ID',
              subtitle: widget.mainUser.id,
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return ChangeUserAttributesWidget(type: UserChangeType.password, mainUser: widget.mainUser,  ancestorContext: widget.ancestorContext);
                  }),
              child: _buildListTile(
                leadingIcon: Icons.lock,
                title: 'Password',
                subtitle: "Change Password",
              ),
            ),
            GestureDetector(
              onTap: (){
                logout();
              },
              child: _buildListTile(
                leadingIcon: Icons.arrow_back,
                title: 'Logout',
                subtitle: "Click to logout",
              ),
            ),
          ],
        )
    );
  }

  Widget _buildListTile({
    required IconData leadingIcon,
    required String title,
    required String subtitle,
    IconData? trailingIcon
  }) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: Card(
        elevation: 0.125,
        // No elevation for the Card; we'll use the shadow from the Container
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
                  ),
                  child: Icon(
                    leadingIcon,
                    color: Colors.white, // Change the icon color as needed
                    size: 25.0, // Adjust the icon size as needed
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold),),
                    Text(subtitle),
                  ],
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                trailingIcon,
                color: Colors.black, // Change the icon color as needed
                size: 25.0, // Adjust the icon size as needed
              ),
            )
          ],
        )
      ),
    );
  }
  void logout() {
    BlocProvider.of<AuthBloc>(widget.ancestorContext)
        .add(const LogoutEvent());
  }
}