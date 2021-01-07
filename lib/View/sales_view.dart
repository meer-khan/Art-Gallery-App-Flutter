import 'package:flutter/material.dart';
import 'package:testing/Database/database.dart';
import 'package:testing/View/admin/artwork_admin.dart';
import 'package:testing/View/payment_view.dart';
import 'package:testing/animation/bottomAnimation.dart';

class Sales extends StatefulWidget {
  final bool isAdmin;
  final int userID;
  Sales({this.isAdmin, this.userID});

  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  bool contactAvail = false;
  bool isJoin = false;
  callBack(boolVar) {
    setState(() {
      contactAvail = boolVar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Text(""),
        title: Text(
          "Arts for Sale",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 3.0),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.scatter_plot),
            onPressed: () {
              setState(() {
                isJoin = !isJoin;
              });
            },
          )
        ],
      ),
      body: !isJoin
          ? FutureBuilder(
              future: _query(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text("No Art for Sale!"),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return WidgetAnimator(
                        Card(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentPage(
                                        artID: snapshot.data[index]['artID'],
                                        userID: widget.userID,
                                        callback: callBack,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: Column(
                                    children: [
                                      Image(
                                          image: AssetImage(
                                              './assets/abstract1min.jpeg')),
                                      ListTile(
                                        title: Text(
                                          snapshot.data[index]['artType']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Price: Rs " +
                                                  snapshot.data[index]
                                                          ['artPrice']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Artist: " +
                                                  snapshot.data[index]
                                                          ['artName']
                                                      .toString(),
                                              style: TextStyle(
                                                  letterSpacing: 2.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              widget.isAdmin
                                  ? Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 10, 0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: IconButton(
                                              color: Colors.white,
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                print("Hello gg");
                                                setState(() {
                                                  _delete(snapshot.data[index]
                                                      ['artID']);
                                                });
                                              }),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
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
            )
          : Container(
              child: FutureBuilder(
              future: _join(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text("No Art for Sale!"),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return WidgetAnimator(
                        Card(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentPage(
                                        artID: snapshot.data[index]['artID'],
                                        userID: widget.userID,
                                        callback: callBack,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: Column(
                                    children: [
                                      Image(
                                          image: AssetImage(
                                              './assets/abstract1min.jpeg')),
                                      ListTile(
                                        title: Text(
                                          snapshot.data[index]['artType']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Dimension: " +
                                                  snapshot.data[index]
                                                          ['sclDimension']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            Text(
                                              "Price: Rs " +
                                                  snapshot.data[index]
                                                          ['artPrice']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Artist: " +
                                                  snapshot.data[index]
                                                          ['artName']
                                                      .toString(),
                                              style: TextStyle(
                                                  letterSpacing: 2.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              widget.isAdmin
                                  ? Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 10, 0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: IconButton(
                                              color: Colors.white,
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                print("Hello gg");
                                                setState(() {
                                                  _delete(snapshot.data[index]
                                                      ['artID']);
                                                });
                                              }),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
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
            )),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminArtWorks(
                      callback: callBack,
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          : Container(),
    );
  }

  final dbHelper = DatabaseHelper.instance;
  Future _query() async {
    final allRows = await dbHelper.queryAllArts();
    return allRows;
  }

  void _delete(int artID) async {
    await dbHelper.deleteArt(artID);
  }

  // join
  Future _join() async {
    final artScl = await dbHelper.joinArtScl();
    return artScl;
  }
}
