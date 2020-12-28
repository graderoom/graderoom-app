import 'package:flutter/material.dart';
import 'package:graderoom_app/theme_model.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

void main() => runApp(ChangeNotifierProvider<ThemeModel>(
    create: (BuildContext context) => ThemeModel(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Graderoom',
      theme: Provider.of<ThemeModel>(context).currentTheme,
      home: MyHomePage(title: 'Graderoom'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.title), actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.login,
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())),
        )
      ]),
      body: Center(),
    );
  }
}
