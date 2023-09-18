import 'package:flutter/material.dart';
import 'package:household_organizer/core/entities/user.dart';

class AccountView extends StatefulWidget {
  final User mainUser;
  const AccountView({super.key, required this.mainUser});


  @override
  State<AccountView> createState() => _AccountView();
}

class _AccountView extends State<AccountView> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, weight: 5.0),
                Text('Account Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              ],
            ),
            const SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildListTile(
                  leadingIcon: Icons.email,
                  title: 'Email',
                  subtitle: widget.mainUser.email,
                ),
                _buildListTile(
                  leadingIcon: Icons.person,
                  title: 'Username',
                  subtitle: widget.mainUser.username,
                ),
                _buildListTile(
                  leadingIcon: Icons.person,
                  title: 'Full Name',
                  subtitle: widget.mainUser.name,
                ),
                _buildListTile(
                  leadingIcon: Icons.confirmation_number,
                  title: 'ID',
                  subtitle: widget.mainUser.id,
                ),
                _buildListTile(
                  leadingIcon: Icons.home,
                  title: 'Current Household',
                  subtitle: widget.mainUser.householdId,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({required IconData leadingIcon, required String title, required String subtitle}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: Card(
        elevation: 0.125,
        // No elevation for the Card; we'll use the shadow from the Container
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey,
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
                Text(title),
                Text(subtitle),
              ],
            )
          ],
        )
      ),
    );
  }
}