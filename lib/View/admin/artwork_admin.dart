import 'package:flutter/material.dart';
import 'package:testing/Database/database.dart';
import 'package:testing/View/admin/artist_admin.dart';

class AdminArtWorks extends StatefulWidget {
  final Function(bool) callback;
  AdminArtWorks({this.callback});
  @override
  _AdminArtWorksState createState() => _AdminArtWorksState();
}

final artworkTypeCont = TextEditingController();
final artworkNameCont = TextEditingController();
final artworkPriceCont = TextEditingController();
final artistIDCont = TextEditingController();

class _AdminArtWorksState extends State<AdminArtWorks> {
  String artType = "Painting";
  String artistName;
  String artPrice;
  int artistID;
  String boardSizeDimen;

  _showSnack(String msg) {
    var snackbar = SnackBar(
      content: Text("$msg"),
      behavior: SnackBarBehavior.floating,
    );

    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("New Artwork"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "ARTWORKS",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: artistIDCont,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Artist ID'),
                  onChanged: (text) {
                    setState(() {
                      artistID = int.parse(text);
                    });
                  },
                ),
                SizedBox(
                  height: 10,
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
                  height: 10,
                ),
                TextFormField(
                  controller: artworkPriceCont,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Artwork Price'),
                  onChanged: (text) {
                    setState(() {
                      artPrice = text;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 35,
                        child: TextFormField(
                          controller: artworkTypeCont,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: artType == "Handicraft" ||
                                      artType == "Sclpture"
                                  ? 'Dimension'
                                  : "Artboard Size"),
                          onChanged: (text) {
                            setState(() {
                              boardSizeDimen = text;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton(
                        value: artType,
                        items: <String>["Painting", "Sclpture", "Handicraft"]
                            .map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (text) {
                          setState(() {
                            artType = text;
                          });
                        }),
                  ],
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
                      insertArt(artType, artistName, artPrice, artistID);
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
      ),
    );
  }

  final dbHelper = DatabaseHelper.instance;
  void insertArt(String type, String name, String price, int artistID) async {
    if (artworkTypeCont.text != '' &&
        artistNameCont.text != '' &&
        artworkPriceCont.text != '' &&
        artistIDCont.text != '') {
      var check = await dbHelper.insertArtWorks(
          type, name, price, artistID, boardSizeDimen);
      if (check == 1) {
        _showSnack("Artist information Mismatch/Doesn't Exist");
      } else {
        artworkTypeCont.clear();
        artistNameCont.clear();
        artworkPriceCont.clear();
        artistIDCont.clear();
        widget.callback(true);
        Navigator.pop(context);
      }
    }
  }
}
