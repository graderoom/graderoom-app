import 'package:flutter/material.dart';
import 'package:graderoom_app/extensions.dart';

class DarkTheme {
  static const String logoPath = 'assets/images/dark/logo.png';

  static final ThemeData themeData = ThemeData(
    fontFamily: 'Montserrat',
    primarySwatch: Colors.blue,
    accentColor: HexColor.fromHex("#444444"),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    backgroundColor: HexColor.fromHex("#333333"),
    brightness: Brightness.dark,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    primaryColor: HexColor.fromHex("#EEEEEE"),
    primaryColorLight: Colors.grey[500],
    primaryColorDark: Colors.black,
    focusColor: HexColor.fromHex("#333333"),
  );

  static final TextStyle labelTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static final BoxDecoration textFieldBoxDecoration = BoxDecoration(
    color: themeData.primaryColorLight,
    borderRadius: BorderRadius.circular(10.0),
  );

  static final InputDecoration textFieldInputDecoration = InputDecoration();

  static final BoxDecoration brandBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
  );
}
