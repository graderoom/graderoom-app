import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:graderoom_app/database/db.dart';
import 'package:graderoom_app/server.dart';
import 'settings_screen.dart';

var db = DB.db;

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
    var grades;
    await for (Response r in Server().checkUpdateBackgroundStream()) {
      grades = r.data['grades'];
    }
    await db.writeCourses(grades);
    print(await db.getCourse(index: 0));
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
      body: GridView.count(
        crossAxisCount: 2,
        children: _buildOverviewGrid(),
      ),
    );
  }

  List<Widget> _buildOverviewGrid() {
    return List<Scaffold>();
  }

  Widget _buildOverviewClassButton() {}
}
