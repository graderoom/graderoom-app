import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:graderoom_app/screens/splashScreen.dart';
import 'package:graderoom_app/theme/themeNotifier.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (BuildContext context) {
        return ThemeNotifier.fromString("dark");
      },
      child: KeyboardVisibilityProvider(
        child: new App(),
      ),
    ),
  );
}

class App extends StatelessWidget with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return KeyboardDismissOnTap(
      child: MaterialApp(
        builder: BotToastInit(),
        debugShowCheckedModeBanner: false,
        title: 'Graderoom',
        theme: themeNotifier.lightTheme,
        darkTheme: themeNotifier.darkTheme,
        themeMode: themeNotifier.themeMode,
        navigatorObservers: [BotToastNavigatorObserver()],
        home: SplashScreen(),
      ),
    );
  }
}
