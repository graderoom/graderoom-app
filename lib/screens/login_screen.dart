import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:graderoom_app/constants.dart';
import 'package:graderoom_app/http_client.dart';
import 'package:graderoom_app/screens/forgot_password_screen.dart';
import 'package:graderoom_app/screens/main_screen.dart';
import 'package:graderoom_app/screens/signup_screen.dart';
import 'package:graderoom_app/theme.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Alignment childAlignment = Alignment.center;
  String loginMessage = "";

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _node.dispose();

    super.dispose();
  }

  void _submit() async {
    var response = await HTTPClient().login(
      _usernameController.text,
      _passwordController.text,
    );
    if (response.statusCode == 200) {
      _usernameController.clear();
      _passwordController.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => MainScreen(),
        ),
      );
    } else {
      setState(() {
        loginMessage = "Invalid Username or Password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _formKey.currentState?.validate();
    return Scaffold(
      body: AnimatedContainer(
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 400),
        width: double.infinity,
        height: double.infinity,
        alignment: childAlignment,
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: FocusScope(
            node: _node,
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 120.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                image: AssetImage(Constants.logoPath),
                                height: 30.0,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                'Graderoom',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          decoration: GraderoomTheme.brandStyle,
                          padding: EdgeInsets.all(20.0),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          '$loginMessage',
                          style: TextStyle(color: Colors.red),
                        ),
                        AutofillGroup(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 30.0),
                              _buildUsernameTF(_node),
                              SizedBox(height: 30.0),
                              _buildPasswordTF(),
                              _buildForgotPasswordBtn(),
                              _buildLoginBtn(),
                              _buildSignupBtn(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameTF(FocusScopeNode _node) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: GraderoomTheme.textFieldStyle,
          height: 60.0,
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.person),
              hintText: 'Enter your Username',
              labelText: 'Username',
            ),
            textInputAction: TextInputAction.next,
            onEditingComplete: _node.nextFocus,
            autofillHints: <String>[AutofillHints.username],
            controller: _usernameController,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: GraderoomTheme.textFieldStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.lock),
              hintText: 'Enter your Password',
              labelText: 'Password',
            ),
            textInputAction: TextInputAction.done,
            onEditingComplete: () => _submit(),
            autofillHints: <String>[AutofillHints.password],
            controller: _passwordController,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 0.0),
      child: FlatButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ForgotPasswordScreen())),
        child: Text(
          "Forgot Password?",
          style: GraderoomTheme.labelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
        padding: EdgeInsets.only(top: 25.0),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () => _submit(),
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.login),
              SizedBox(width: 5.0),
              Text("LOGIN"),
            ],
          ),
        ));
  }

  Widget _buildSignupBtn() {
    return Container(
      child: FlatButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignupScreen())),
        child: Text(
          "SIGNUP",
          style: TextStyle(color: Theme.of(context).buttonColor),
        ),
      ),
    );
  }
}
