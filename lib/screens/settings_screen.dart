import 'package:flutter/material.dart';
import 'package:graderoom_app/http_client.dart';
import 'package:graderoom_app/screens/login_screen.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    _logout(context) async {
      await HTTPClient().logout();

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SettingsList(
        backgroundColor: Colors.transparent,
        sections: [
          SettingsSection(
            title: 'Appearance',
            tiles: [
              SettingsTile(
                title: 'Theme',
                subtitle: 'System Default',
                leading: Icon(Icons.brightness_4),
              ),
            ],
          ),
          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(
                title: 'Logout',
                leading: Icon(Icons.logout),
                onPressed: (context) => _logout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
