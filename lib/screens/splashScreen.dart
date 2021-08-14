import 'package:flutter/material.dart';
import 'package:graderoom_app/database/db.dart';
import 'package:graderoom_app/database/preferenceEnums.dart';
import 'package:graderoom_app/database/secureStorage.dart';
import 'package:graderoom_app/httpClient.dart';
import 'package:graderoom_app/overlays/toaster.dart';
import 'package:graderoom_app/screens/loginScreen.dart';
import 'package:graderoom_app/screens/mainScreen.dart';
import 'package:graderoom_app/theme/themeNotifier.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  String infoText = "";

  @override
  void initState() {
    _init();
    super.initState();
  }

  void updateInfoText(String infoText) {
    toastDebug(infoText);
    this.infoText += "\n" + infoText;
    setState(() {});
  }

  Future<void> _init() async {
    var home;
    var cookie = await HTTPClient.cookie;
    updateInfoText("Initializing...");
    if (cookie != null) {
      updateInfoText("Found saved cookie...");
      var now = DateTime.now();
      if (cookie.expires != null && now.isBefore(cookie.expires!)) {
        updateInfoText("Attempting login with cookie...");
        var loggedIn = await HTTPClient().getStatus();
        if (loggedIn?.statusCode == 200) {
          updateInfoText("Cookie login successful!");
          home = MainScreen();
        } else {
          updateInfoText("Cookie login failed...");
        }
      }
    } else {
      updateInfoText("No saved cookie...");
    }
    if (home == null) {
      updateInfoText("Checking saved credentials...");
      var credentials = await SecureStorage.getLoginInformation();
      if (credentials["username"] != null && credentials["password"] != null) {
        updateInfoText("Found saved credentials...");
        updateInfoText("Attempting login with saved credentials...");
        var response = await HTTPClient().login(
          credentials["username"]!,
          credentials["password"]!,
          true,
        );
        if (response?.statusCode == 200) {
          updateInfoText("Login successful!");
          home = MainScreen();
        }
      } else {
        updateInfoText("No saved credentials...");
      }
    }
    updateInfoText("Initializing app...");
    await DB.database;
    Provider.of<ThemeNotifier>(context, listen: false).setThemeModeFromTheme(themeEnumValues[DB.getLocal("theme")]);
    home ??= LoginScreen();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => home,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: 100,
              width: 100,
              child: Image.asset("assets/images/dark/logo.png"),
            ),
          ),
          Text(
            infoText,
          ),
        ],
      ),
    );
  }
}
