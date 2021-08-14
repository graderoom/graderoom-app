import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graderoom_app/httpClient.dart';
import 'package:graderoom_app/screens/forgotPasswordScreen.dart';
import 'package:graderoom_app/screens/mainScreen.dart';
import 'package:graderoom_app/screens/signupScreen.dart';
import 'package:graderoom_app/screens/splashScreen.dart';
import 'package:graderoom_app/theme/themeNotifier.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginForm();
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with WidgetsBindingObserver {
  late ThemeNotifier _themeNotifier;

  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Alignment childAlignment = Alignment.center;
  String loginMessage = "";
  bool stayLoggedIn = true;

  @override
  void initState() {
    _initState();
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _node.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    _themeNotifier.init();
    super.didChangePlatformBrightness();
  }

  void _initState() async {
    Response<dynamic>? status = await HTTPClient().getStatus();
    if (status?.statusCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => MainScreen(),
        ),
      );
    }
  }

  void _submit() async {
    Response<dynamic>? response = await HTTPClient().login(
      _usernameController.text,
      _passwordController.text,
      stayLoggedIn,
    );
    if (response == null) return;
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
    _themeNotifier = Provider.of<ThemeNotifier>(context);
    _formKey.currentState?.validate();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SplashScreen()),
        ),
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
                          decoration: _themeNotifier.brandBoxDecoration,
                          padding: EdgeInsets.all(20.0),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          '$loginMessage',
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            AutofillGroup(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 30.0),
                                  _buildUsernameTF(_node),
                                  SizedBox(height: 30.0),
                                  _buildPasswordTF(),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _buildStayLoggedInCheckbox(),
                                _buildForgotPasswordBtn(),
                              ],
                            ),
                            _buildLoginBtn(),
                            _buildSignupBtn(),
                          ],
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
          decoration: _themeNotifier.textFieldBoxDecoration,
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
          decoration: _themeNotifier.textFieldBoxDecoration,
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

  Widget _buildStayLoggedInCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "Stay Logged In",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Checkbox(
          value: stayLoggedIn,
          onChanged: (value) {
            setState(() {
              stayLoggedIn = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 0.0),
      child: TextButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ForgotPasswordScreen())),
        child: Text(
          "Forgot Password?",
          style: _themeNotifier.labelTextStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
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
              Text("LOGIN"),
            ],
          ),
        ));
  }

  Widget _buildSignupBtn() {
    return Container(
      child: TextButton(
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
