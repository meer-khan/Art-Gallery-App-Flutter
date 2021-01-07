import 'package:flutter/material.dart';
import 'package:testing/Database/database.dart';
import 'package:testing/animation/bottomAnimation.dart';

class Artist extends StatefulWidget {
  final bool isAdmin;
  Artist({this.isAdmin});

  @override
  _ArtistState createState() => _ArtistState();
}

class _ArtistState extends State<Artist> {
  bool contactAvail = false;

  callBack(boolVar) {
    setState(() {
      contactAvail = boolVar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: Text(
          "Artists",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 3.0),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _query(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: Text("No Artist Found!"),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return WidgetAnimator(
                  Card(
                    child: ListTile(
                      leading: Text(snapshot.data[index]['aID'].toString()),
                      title: Text(snapshot.data[index]['aName'].toString()),
                      trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _delete(snapshot.data[index]['aID']);
                            });
                          }),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminArtist(
                      callback: callBack,
                    ),
                  ),
                );
              },
              child: Icon(Icons.add))
          : Container(),
    );
  }

  final dbHelper = DatabaseHelper.instance;
  Future _query() async {
    final allRows = await dbHelper.queryAllArtist();
    return allRows;
  }

  void _delete(int artistName) async {
    await dbHelper.deleteArtist(artistName);
    setState(() {});
  }
}

class AdminArtist extends StatefulWidget {
  final Function(bool) callback;
  AdminArtist({this.callback});
  @override
  _AdminArtistState createState() => _AdminArtistState();
}

final artistNameCont = TextEditingController();

class _AdminArtistState extends State<AdminArtist> {
  String artistName;

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
        title: Text("New Artist"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "ARTIST",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: artistNameCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Artist Name'),
                onChanged: (text) {
                  setState(() {
                    artistName = text;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                height: 45,
                child: FlatButton(
                  shape: StadiumBorder(),
                  color: Colors.orange,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _insertArtist(artistName);
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: const Text('Insert', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final dbHelper = DatabaseHelper.instance;
  void _insertArtist(String artistName) async {
    if (artistNameCont.text != '') {
      await dbHelper.insertArtist(artistName);
      artistNameCont.clear();
      widget.callback(true);
      Navigator.pop(context);
    } else {
      _showSnack('Empty Field(s) Found!');
    }
  }
}
