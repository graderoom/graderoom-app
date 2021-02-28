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
  SettingsScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsScreen> with WidgetsBindingObserver {
  ThemeNotifier _themeNotifier;

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
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: _themeNotifier.iconColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: _themeNotifier.iconColor,
        ),
      ),
      body: SettingsList(
        backgroundColor: Theme.of(context).backgroundColor,
        sections: [
          _buildAppearanceSettings(context),
          CustomSection(
            child: SizedBox(height: 15.0),
          ),
          _buildAccountSettings(context),
          _buildAdvancedSettings(context),
        ],
      ),
    );
  }

  Widget _buildAppearanceSettings(BuildContext context) {
    return CustomSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_4),
            title: Text('Theme'),
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
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return CustomSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SettingsTile(
            leading: Icon(Icons.logout),
            title: 'Logout',
            onPressed: (context) => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings(BuildContext context) {
    return CustomSection(
      child: ExpandableNotifier(
        initialExpanded: DB.getLocal("showDebugToasts"),
        child: ExpandablePanel(
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
                    ),
                  ),
                  ExpandableIcon(
                    theme: ExpandableThemeData(
                      iconColor: _themeNotifier.iconColor,
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
