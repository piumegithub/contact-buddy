import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          
          ListTile(
            title: Text('Contacts Buddy Application'),
            subtitle: Text('Demo Preview'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.app_registration,size: 32,),
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: 32,
            ),
            title: Text('Created by'),
            subtitle: Text('Piume Manikkuwadura'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
