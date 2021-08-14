import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graderoom_app/screens/loginScreen.dart';
import 'package:graderoom_app/theme/themeNotifier.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignupForm(),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> with WidgetsBindingObserver {
  late ThemeNotifier _themeNotifier;

  @override
  void didChangePlatformBrightness() {
    _themeNotifier.init();
    super.didChangePlatformBrightness();
  }

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _schoolEmailController = TextEditingController();
  final _betaKeyController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _schoolEmailController.dispose();
    _betaKeyController.dispose();

    super.dispose();
  }

  void _submit() async {}

  @override
  Widget build(BuildContext context) {
    _themeNotifier = Provider.of<ThemeNotifier>(context);
    _formKey.currentState?.validate();
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage(_themeNotifier.logoPath),
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
                  SizedBox(height: 30.0),
                  _buildUsernameTF(),
                  SizedBox(height: 30.0),
                  _buildPasswordTF(),
                  SizedBox(height: 30.0),
                  _buildConfirmPasswordTF(),
                  SizedBox(height: 30.0),
                  _buildSchoolEmailTF(),
                  SizedBox(height: 30.0),
                  _buildBetaKeyTF(),
                  _buildSignupBtn(),
                  _buildLoginBtn(),
                ],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Text(
                "NOT FUNCTIONAL",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: _themeNotifier.textFieldBoxDecoration,
          height: 60.0,
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.person),
              hintText: 'Enter a Username',
              labelText: 'Username',
            ),
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
          decoration: _themeNotifier.textFieldBoxDecoration,
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.lock),
              hintText: 'Enter a Password',
              labelText: 'Password',
            ),
            autofillHints: <String>[AutofillHints.password],
            controller: _passwordController,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: _themeNotifier.textFieldBoxDecoration,
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.lock),
              hintText: 'Confirm your Password',
              labelText: 'Confirm Password',
            ),
            autofillHints: <String>[AutofillHints.password],
            controller: _confirmPasswordController,
          ),
        ),
      ],
    );
  }

  Widget _buildSchoolEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: _themeNotifier.textFieldBoxDecoration,
          height: 60.0,
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.mail_outline_rounded),
              hintText: 'Enter your school email',
              labelText: 'School Email',
            ),
            autofillHints: <String>[AutofillHints.email],
            controller: _schoolEmailController,
          ),
        ),
      ],
    );
  }

  Widget _buildBetaKeyTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: _themeNotifier.textFieldBoxDecoration,
          height: 60.0,
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.vpn_key),
              hintText: 'Enter your beta key',
              labelText: 'Beta Key',
            ),
            controller: _betaKeyController,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupBtn() {
    return Container(
        padding: EdgeInsets.only(top: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _submit(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.login),
              SizedBox(width: 5.0),
              Text("SIGNUP"),
            ],
          ),
        ));
  }

  Widget _buildLoginBtn() {
    return Container(
      child: TextButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen())),
        child: Text(
          "LOGIN",
          style: TextStyle(color: Theme.of(context).buttonColor),
        ),
      ),
    );
  }
}
