import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graderoom_app/database/db.dart';
import 'package:graderoom_app/http_client.dart';
import 'package:graderoom_app/screens/settings_screen.dart';

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
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: db.length,
      itemBuilder: (BuildContext context, int index) => Container(
        child: _buildOverviewGridCard(index),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
    );
  }

  Card _buildOverviewGridCard(int index) {
    var course = db.get(index);
    var className = course["class_name"];
    var overallPercent = course["overall_percent"];
    var overallLetter = course["overall_letter"];
    return Card(
      margin: EdgeInsets.all(5.0),
      semanticContainer: true,
      color: Theme.of(context).primaryColor,
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: Column(
          children: <Widget>[
            Text(
              "$className",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Text(
              "$overallLetter",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 80.0,
              ),
            ),
            Text(
              "$overallPercent%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
