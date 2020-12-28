import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class LoginScreen extends StatelessWidget {
  usernameValidator(username) async {
    var url = Constants.baseURL + 'usernameAvailable';
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildUsernameTF() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Graderoom Username', style: Constants.kLabelStyle),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: Constants.kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                    hintText: 'Enter your Username')),
          ),
        ],
      );
    }

    Widget _buildPasswordTF() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Graderoom Password', style: Constants.kLabelStyle),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: Constants.kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    hintText: 'Enter your Password')),
          ),
        ],
      );
    }

    Widget _buildForgotPasswordBtn() {
      return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 0.0),
        child: FlatButton(
          onPressed: () => print("Forgot password btn pressed"),
          child: Text("Forgot Password?", style: Constants.kLabelStyle),
        ),
      );
    }

    Widget _buildLoginBtn() {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 25.0),
          width: double.infinity,
          child: RaisedButton(
            elevation: 5.0,
            onPressed: () => print("Login button pressed"),
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.login, color: Colors.white),
                SizedBox(width: 5.0),
                Text("LOGIN")
              ],
            ),
          ));
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(height: double.infinity, width: double.infinity),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Sign In',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 30.0),
                  _buildUsernameTF(),
                  SizedBox(height: 30.0),
                  _buildPasswordTF(),
                  _buildForgotPasswordBtn(),
                  _buildLoginBtn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
