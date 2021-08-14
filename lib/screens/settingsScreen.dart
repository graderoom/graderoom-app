import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:graderoom_app/database/db.dart';
import 'package:graderoom_app/database/preferenceEnums.dart';
import 'package:graderoom_app/extensions.dart';
import 'package:graderoom_app/httpClient.dart';
import 'package:graderoom_app/screens/loginScreen.dart';
import 'package:graderoom_app/theme/themeNotifier.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> with WidgetsBindingObserver {
  late ThemeNotifier _themeNotifier;

  @override
  void didChangePlatformBrightness() {
    _themeNotifier.init();
    super.didChangePlatformBrightness();
  }

  Future<void> _logout(context) async {
    await HTTPClient().logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      (route) => false,
    );
  }

  Widget build(BuildContext context) {
    _themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: _themeNotifier.appBar(
        context: context,
        title: Text(
          "Settings",
          style: TextStyle(
            color: _themeNotifier.iconColor,
          ),
        ),
      ),
      body: SettingsList(
        backgroundColor: Theme.of(context).backgroundColor,
        sections: [
          _buildAppearanceSettings(context),
          _buildAccountSettings(context),
          _buildAdvancedSettings(context),
        ],
      ),
    );
  }

  SettingsSection _buildAppearanceSettings(BuildContext context) {
    return SettingsSection(
      title: "Appearance",
      tiles: <SettingsTile>[
        SettingsTile(
          leading: Icon(Icons.brightness_4),
          title: 'Theme',
          subtitle: "This only applies to this device",
          subtitleMaxLines: 3,
          trailing: Container(
            padding: EdgeInsets.only(right: 30.0),
            child: DropdownButton(
                icon: Icon(Icons.arrow_drop_down),
                value: DB.getLocal("theme"),
                items: Themes.values
                    .map<DropdownMenuItem<String>>(
                      (Themes theme) => DropdownMenuItem<String>(
                        value: theme.toString().substring(7).toLowerCase().capitalize(),
                        child: Text(
                          theme.toString().substring(7).toLowerCase().capitalize(),
                        ),
                      ),
                    )
                    .toList(),
                underline: Container(),
                onChanged: (theme) async {
                  await _themeNotifier.setThemeModeFromTheme(themeEnumValues[theme]);
                  setState(() {});
                }),
          ),
        ),
      ],
    );
  }

  SettingsSection _buildAccountSettings(BuildContext context) {
    bool stayLoggedIn = DB.getLocal("stayLoggedIn");

    return SettingsSection(
      title: 'Account',
      tiles: <SettingsTile>[
        SettingsTile.switchTile(
          leading: Icon(Icons.security),
          title: "Always Stay Logged In",
          subtitle: stayLoggedIn
              ? "Securely store credentials and login automatically when your cookie expires"
              : "Login with the 'Stay Logged In' option enabled to set this up",
          subtitleTextStyle: TextStyle(color: stayLoggedIn ? null : Colors.blue),
          subtitleMaxLines: 4,
          onToggle: (value) async {
            await DB.setLocal("stayLoggedIn", value);
            setState(() {});
          },
          switchValue: stayLoggedIn,
          enabled: stayLoggedIn,
        ),
        SettingsTile(
          leading: Icon(Icons.logout),
          title: 'Logout',
          subtitle: "Erase all stored credentials and sign out",
          subtitleMaxLines: 4,
          onPressed: (context) => _logout(context),
        ),
      ],
    );
  }

  CustomSection _buildAdvancedSettings(BuildContext context) {
    return CustomSection(
      child: ExpandableNotifier(
        initialExpanded: DB.getLocal("showDebugToasts"),
        child: ExpandablePanel(
          collapsed: Container(),
          theme: ExpandableThemeData(
            hasIcon: false,
          ),
          header: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Advanced',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  ExpandableIcon(
                    theme: ExpandableThemeData(
                      iconColor: Theme.of(context).accentColor,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      iconPlacement: ExpandablePanelIconPlacement.right,
                      expandIcon: Icons.keyboard_arrow_down,
                      collapseIcon: Icons.keyboard_arrow_up,
                    ),
                  ),
                ],
              ),
            ),
          ),
          expanded: SettingsTile.switchTile(
            leading: Icon(Icons.developer_mode),
            title: "Show Debug Toasts",
            subtitle: "Display timestamped toasts of all log messages",
            subtitleMaxLines: 6,
            onToggle: (value) async {
              await DB.setLocal("showDebugToasts", value);
              setState(() {});
            },
            switchValue: DB.getLocal("showDebugToasts"),
          ),
        ),
      ),
    );
  }
}
