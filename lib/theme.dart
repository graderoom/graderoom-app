import 'package:flutter/material.dart';

class GraderoomTheme {
  static final ThemeData darkTheme = ThemeData.dark();

  // Todo change in-app icon dynamically
  static final ThemeData lightTheme = ThemeData.light();

  static final hintStyle = TextStyle(
    fontFamily: 'Montserrat',
  );

  static final labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
  );

  static final textFieldStyle = BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(10.0),
  );

  static final brandStyle = BoxDecoration(
    gradient: RadialGradient(
      center: Alignment.centerLeft,
      colors: [Colors.black, Colors.grey],
      stops: [0.5, 1],
      radius: 2.0,
    ),
    borderRadius: BorderRadius.circular(10.0),
  );
}
