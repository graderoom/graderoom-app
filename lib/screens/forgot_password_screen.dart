import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body:
      Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Text(
            "NOT FUNCTIONAL",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 50.0,
            ),
          ),
        ),
      ),
    );
  }
}
