import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graderoom_app/theme/themeNotifier.dart';
import 'package:graderoom_app/httpClient.dart';
import 'package:graderoom_app/screens/loginScreen.dart';
import 'package:graderoom_app/screens/mainScreen.dart';
import 'package:provider/provider.dart';

import 'database/db.dart';

var home;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await DB.database;

  var cookie = await HTTPClient.cookie;
  if (cookie != null) {
    var now = DateTime.now();
    if (now.isBefore(cookie.expires)) {
      var loggedIn = await HTTPClient().getStatus(
        showToast: false,
        showLoading: false,
      );
      if (loggedIn?.statusCode == 200) {
        home = MainScreen();
      } else {
        home = LoginScreen();
      }
    }
  } else {
    home = LoginScreen();
  }

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (BuildContext context) {
        return ThemeNotifier.fromString(DB.getLocal("theme"));
      },
      child: new App(),
    ),
  );
}

class App extends StatelessWidget with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return GestureDetector(
      onTap: () {
        FocusNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.children != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        builder: BotToastInit(),
        debugShowCheckedModeBanner: false,
        title: 'Graderoom',
        theme: themeNotifier.lightTheme,
        darkTheme: themeNotifier.darkTheme,
        themeMode: themeNotifier.themeMode,
        navigatorObservers: [BotToastNavigatorObserver()],
        home: home,
      ),
    );
  }
}
