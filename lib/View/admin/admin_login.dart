import 'package:flutter/material.dart';
import 'package:testing/View/homeScreen_view.dart';

final adminCodeCont = TextEditingController();

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showSnackBar() {
    var snackbar = SnackBar(
      content: Text("Invalid Admin Code"),
      behavior: SnackBarBehavior.floating,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _adminHeader() {
    return Column(
      children: [
        Icon(
          Icons.admin_panel_settings,
          size: 80,
        ),
        Text(
          "Admin",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3.0),
        )
      ],
    );
  }

  String code;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            adminCodeCont.clear();
            Navigator.pop(context);
          },
        ),
        title: Text("Admin Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _adminHeader(),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                obscureText: true,
                controller: adminCodeCont,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.admin_panel_settings),
                    border: OutlineInputBorder(),
                    labelText: 'Enter Admin Password'),
                onChanged: (text) {
                  setState(() {
                    code = text;
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
                  textColor: Colors.white,
                  color: Colors.orange,
                  onPressed: () {
                    if (code == 'admin') {
                      adminCodeCont.clear();
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            isAdmin: true,
                          ),
                        ),
                      );
                    } else {
                      _showSnackBar();
                    }
                  },
                  child: Text("Admin Login"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
