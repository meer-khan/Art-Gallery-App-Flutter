import 'package:flutter/material.dart';
import 'package:testing/Database/database.dart';

class AdminExhibitions extends StatefulWidget {
  final Function(bool) callback;
  AdminExhibitions({this.callback});
  @override
  _AdminExhibitionsState createState() => _AdminExhibitionsState();
}

final eTypeCont = TextEditingController();
final eDateCont = TextEditingController();
final eTimeCont = TextEditingController();
final eLocCont = TextEditingController();

class _AdminExhibitionsState extends State<AdminExhibitions> {
  final dbHelper = DatabaseHelper.instance;
  String eType;
  String eDate;
  String eTime;
  String eLocation;

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
        title: Text("Add Exhibitions"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "EXHIBITIONS",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: eTypeCont,
                  onChanged: (text) {
                    setState(() {
                      eType = text;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Exhibition Type'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: eTimeCont,
                  onChanged: (text) {
                    setState(() {
                      eTime = text;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Exhibition Time'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: eDateCont,
                  onChanged: (text) {
                    setState(() {
                      eDate = text;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Exhibition Date'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: eLocCont,
                  onChanged: (text) {
                    setState(() {
                      eLocation = text;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Exhibition Location'),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: FlatButton(
                    shape: StadiumBorder(),
                    color: Colors.orange,
                    onPressed: () {
                      _insertExh(eType, eTime, eDate, eLocation);
                    },
                    textColor: Colors.white,
                    padding: EdgeInsets.all(0.0),
                    child: Text('Insert', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // CRUD Operations

  void _insertExh(
      String type, String time, String date, String location) async {
    if (eTypeCont.text != '' &&
        eTimeCont.text != '' &&
        eDateCont.text != '' &&
        eLocCont.text != '') {
      await dbHelper.insertExhibition(type, time, date, location);
      eTypeCont.clear();
      eTimeCont.clear();
      eDateCont.clear();
      eLocCont.clear();
      widget.callback(true);
      Navigator.pop(context);
    } else {
      _showSnack('Empty Field(s) Found!');
    }
  }
}
