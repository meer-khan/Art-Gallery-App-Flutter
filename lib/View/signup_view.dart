import 'package:flutter/material.dart';
import 'package:testing/Database/database.dart';

final emailCont = TextEditingController();
final fNameCont = TextEditingController();
final lNameCont = TextEditingController();
final passCont = TextEditingController();

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final dbHelper = DatabaseHelper.instance;
  String userEmail;
  String userFName;
  String userLName;
  String userPass;

  Widget _heading() {
    return Text(
      "Sign Up",
      style: TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showSnack(String msg) {
    var snackbar = SnackBar(
      content: Text("$msg"),
      behavior: SnackBarBehavior.floating,
    );

    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Welcome :)"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              _heading(),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.alternate_email),
                    labelText: 'Enter Email'),
                onChanged: (text) {
                  setState(() {
                    userEmail = text;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: fNameCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    labelText: 'First Name'),
                onChanged: (text) {
                  setState(() {
                    userFName = text;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: lNameCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Last Name'),
                onChanged: (text) {
                  setState(() {
                    userLName = text;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passCont,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password'),
                onChanged: (text) {
                  setState(() {
                    userPass = text;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 180,
                height: 40,
                child: FlatButton(
                  color: Colors.orange,
                  shape: StadiumBorder(),
                  onPressed: () {
                    // User Insert
                    if (emailCont.text != '' &&
                        fNameCont.text != '' &&
                        lNameCont.text != '' &&
                        passCont.text != '') {
                      _insertUser();
                      emailCont.clear();
                      fNameCont.clear();
                      lNameCont.clear();
                      passCont.clear();

                      Navigator.pop(context);
                    } else {
                      _showSnack("Empty Field(s) Found!");
                    }
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _insertUser() async {
    await dbHelper.insertUser(userEmail, userFName, userLName, userPass);
  }
}
