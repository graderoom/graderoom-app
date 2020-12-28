import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'Graderoom';
  static const String logoPath = 'assets/images/logo.png';
  static const String baseURL = 'http://10.0.0.2:5998/';

  static final kHintTextStyle = TextStyle(
    fontFamily: 'OpenSans',
  );

  static final kLabelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  static final kBoxDecorationStyle = BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
}
