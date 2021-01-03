import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../server_connect.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Main();
  }
}

class Main extends StatefulWidget {
  @override
  MainState createState() {
    return MainState();
  }
}

class MainState extends State<Main> {
  void checkUpdateBackground() async {
    await for (Response r in ServerConnect().checkUpdateBackgroundStream()) {
      print(r.data['grades']);
    }
  }

  @override
  void initState() {
    checkUpdateBackground();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => SettingsScreen(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
