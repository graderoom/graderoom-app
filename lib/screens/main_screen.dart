import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:graderoom_app/database/db.dart';
import 'package:graderoom_app/http_client.dart';
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
    await for (Response r in HTTPClient().checkUpdateBackgroundStream()) {
      grades = r.data['grades'];
    }
    await db.writeCourses(grades);
    setState(() {});
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
      body: _buildOverviewGrid(),
    );
  }

  Widget _buildOverviewGrid() {
    return GridView.count(
      crossAxisCount: 2,
      children: _buildOverviewGridItems(),
    );
  }

  List<Center> _buildOverviewGridItems() {
    List<Center> items = [];
    var numItems = db.length;
    for (var i = 0; i < numItems; i++) {
      items.add(_buildOverviewGridItem(i));
    }
    return items;
  }

  Center _buildOverviewGridItem(int index) {
    var course = db.get(index);
    var className = course["class_name"];
    var overallPercent = course["overall_percent"];
    var overallLetter = course["overall_letter"];
    return Center(child: Text("$className - $overallPercent ($overallLetter)"));
  }
}
