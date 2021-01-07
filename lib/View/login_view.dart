import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testing/Database/database.dart';
import 'package:testing/View/admin/admin_login.dart';
import 'package:testing/View/homeScreen_view.dart';
import 'package:testing/View/signup_view.dart';
import 'package:testing/animation/bottomAnimation.dart';

// LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final loginEmailCont = TextEditingController();
final loginPassCont = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final dbHelper = DatabaseHelper.instance;
  String email;
  String password;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: new Text(
              "Exit Application",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: new Text("Are You Sure?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                shape: StadiumBorder(),
                color: Colors.white,
                child: new Text(
                  "No",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                shape: StadiumBorder(),
                color: Colors.white,
                child: new Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget _loginHeader() {
    return Column(
      children: [
        WidgetAnimator(
          Icon(
            Icons.person,
            size: 80,
          ),
        ),
        Text(
          "LOGIN",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _loginHeader(),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: loginEmailCont,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: WidgetAnimator(Icon(Icons.alternate_email)),
                        labelText: 'Enter Email'),
                    onChanged: (text) {
                      setState(() {
                        email = text;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: loginPassCont,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: WidgetAnimator(Icon(Icons.lock)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Enter Password'),
                    onChanged: (text) {
                      setState(() {
                        password = text;
                      });
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: FlatButton(
                      shape: StadiumBorder(),
                      color: Colors.orange,
                      onPressed: () {
                        loginUser(email, password);
                      },
                      textColor: Colors.white,
                      padding: EdgeInsets.all(0.0),
                      child: WidgetAnimator(
                          Text('Login', style: TextStyle(fontSize: 18))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        textColor: Colors.blue,
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                      FlatButton(
                        textColor: Colors.orange,
                        child: Text("Admin Login"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminLogin()));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  clearController() {
    loginEmailCont.clear();
    loginPassCont.clear();
  }

  void loginUser(String email, String password) async {
    var user = await dbHelper.queryLoginUser(email, password);

    if (user != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            isAdmin: false,
            userID: user,
          ),
        ),
      );
      FocusScope.of(context).unfocus();
      clearController();
    } else {
      FocusScope.of(context).unfocus();
      var snackbar = SnackBar(
        content: Text("User Doesn't Exists"),
        behavior: SnackBarBehavior.floating,
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
}
