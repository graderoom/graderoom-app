import 'package:flutter/material.dart';
import 'package:graderoom_app/extensions.dart';

class LightTheme {
  static const String logoPath = 'assets/images/light/logo.png';

  static final ThemeData themeData = ThemeData(
    fontFamily: 'Montserrat',
    primarySwatch: Colors.blue,
    accentColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0.0,
    ),
    brightness: Brightness.light,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    cardColor: HexColor.fromHex("#FFFFFF"),
    backgroundColor: HexColor.fromHex("#E5E5E5"),
    primaryColor: HexColor.fromHex("#000000"),
  );

  static final BoxDecoration textFieldBoxDecoration = BoxDecoration(
    color: themeData.primaryColorLight,
    borderRadius: BorderRadius.circular(10.0),
  );
}
