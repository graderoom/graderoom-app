import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graderoom_app/http_client.dart';
import 'package:graderoom_app/screens/login_screen.dart';
import 'package:graderoom_app/screens/main_screen.dart';
import 'package:graderoom_app/theme.dart';

var home;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  var cookie = await HTTPClient.cookie;
  if (cookie != null) {
    var now = DateTime.now();
    if (now.isBefore(cookie.expires)) {
      var loggedIn = await HTTPClient().getStatus();
      if (loggedIn.statusCode == 200) {
        home = MainScreen();
      } else {
        home = LoginScreen();
      }
    }
  } else {
    home = LoginScreen();
  }

  runApp(new App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.children != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Graderoom',
        theme: GraderoomTheme.lightTheme,
        darkTheme: GraderoomTheme.darkTheme,
        home: home,
      ),
    );
  }
}
