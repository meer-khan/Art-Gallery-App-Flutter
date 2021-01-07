import 'package:flutter/material.dart';
import 'package:testing/Database/database.dart';
import 'package:testing/View/admin/artist_admin.dart';
import 'package:testing/View/admin/exhibition_admin.dart';
import 'package:testing/View/admin/payment_admin.dart';
import 'package:testing/View/sales_view.dart';
import 'package:testing/animation/bottomAnimation.dart';

// Home SCREEN
class HomeScreen extends StatefulWidget {
  final bool isAdmin;
  final int userID;
  HomeScreen({this.isAdmin, this.userID});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  _onTapBottomBarHandle(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget _screenWidget() {
    if (selectedIndex == 0) {
      return HomeScreenView(
        isAdmin: widget.isAdmin,
      );
    } else if (selectedIndex == 1) {
      return Sales(
        isAdmin: widget.isAdmin,
        userID: widget.userID,
      );
    } else if (selectedIndex == 2) {
      return Artist(
        isAdmin: widget.isAdmin,
      );
    } else {
      return widget.isAdmin ? OrderAdmin() : Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screenWidget(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: _onTapBottomBarHandle,
          selectedIconTheme: IconThemeData(color: Colors.orange),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          fixedColor: Colors.orange,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Exhibitions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Sales',
            ),
            if (widget.isAdmin)
              BottomNavigationBarItem(
                icon: Icon(Icons.format_paint),
                label: 'Artists',
              ),
            if (widget.isAdmin)
              BottomNavigationBarItem(
                icon: Icon(Icons.payment),
                label: 'Orders',
              ),
          ],
        ),
      ),
    );
  }
}

// Home View
class HomeScreenView extends StatefulWidget {
  final bool isAdmin;
  HomeScreenView({this.isAdmin});
  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final dbHelper = DatabaseHelper.instance;
  bool contactAvail = false;
  callBack(boolVar) {
    setState(() {
      contactAvail = boolVar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // leading: Text(""),
          title: Text(
            "Exhibitions",
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
                  child: Text("No Data Found!"),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return WidgetAnimator(
                    Card(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Column(
                              children: [
                                Image(
                                  height: 250,
                                  image: AssetImage(
                                    './assets/backgroundimage.jpg',
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    snapshot.data[index]['eType'].toString(),
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index]['eLocation']
                                            .toString(),
                                        style: TextStyle(letterSpacing: 2.0),
                                      ),
                                      Text(
                                        snapshot.data[index]['eDate']
                                            .toString(),
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(
                                        snapshot.data[index]['eTime']
                                            .toString(),
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          widget.isAdmin
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(0, 25, 25, 0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // CircleAvatar(
                                        //   backgroundColor: Colors.green,
                                        //   child: IconButton(
                                        //     color: Colors.white,
                                        //     icon: Icon(Icons.edit),
                                        //     onPressed: () {
                                        //       eTypeCont.text =
                                        //           snapshot.data[index]['eType'];
                                        //       eDateCont.text =
                                        //           snapshot.data[index]['eDate'];
                                        //       eTimeCont.text =
                                        //           snapshot.data[index]['eType'];
                                        //       eLocCont.text =
                                        //           snapshot.data[index]['eType'];
                                        //       Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               AdminExhibitions(
                                        //             callback: callBack,
                                        //           ),
                                        //         ),
                                        //       );
                                        //     },
                                        //   ),
                                        // ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: IconButton(
                                              color: Colors.white,
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                setState(() {
                                                  _delete(snapshot.data[index]
                                                      ['eType']);
                                                });
                                              }),
                                        ),
                                      ],
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
        ),
        floatingActionButton: widget.isAdmin
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminExhibitions(
                        callback: callBack,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.add))
            : Container(),
      ),
    );
  }

  Future _query() async {
    final allRows = await dbHelper.queryAllRows();
    return allRows;
  }

  void _delete(String eName) async {
    await dbHelper.delete(eName);
  }
}
