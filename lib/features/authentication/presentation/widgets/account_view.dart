import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/change_user_attributes_widget.dart';
import 'package:household_organizer/features/household/presentation/pages/household_page.dart';

class AccountView extends StatefulWidget {
  final User mainUser;
  final BuildContext ancestorContext;
  const AccountView({
    super.key,
    required this.mainUser,
    required this.ancestorContext
  });


  @override
  State<AccountView> createState() => _AccountView();
}

class _AccountView extends State<AccountView> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, weight: 5.0),
                const Text(' Account Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                IconButton(onPressed: () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(LoadAuthEvent());
                }, icon: const Icon(Icons.update)),
              ],
            ),
            const SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () => showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return ChangeUserAttributesWidget(type: UserChangeType.email, mainUserID: widget.mainUser.id,  ancestorContext: widget.ancestorContext);
                  }),
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
                        return ChangeUserAttributesWidget(type: UserChangeType.username, mainUserID: widget.mainUser.id, ancestorContext: widget.ancestorContext);
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
                        return ChangeUserAttributesWidget(type: UserChangeType.name, mainUserID: widget.mainUser.id, ancestorContext: widget.ancestorContext);
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
                HouseholdPage(mainUser: widget.mainUser)
              ],
            ),
          ],
        ),
      ),
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
              padding: EdgeInsets.symmetric(horizontal: 10.0),
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
}