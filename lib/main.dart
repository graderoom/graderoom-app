import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graderoom_app/screens/login_screen.dart';
import 'package:graderoom_app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
        theme: lightTheme,
        darkTheme: darkTheme,
        home: LoginScreen(),
      ),
    );
  }
}
