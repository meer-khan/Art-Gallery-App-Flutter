import 'package:flutter/material.dart';
import 'package:testing/Database/database.dart';
import 'package:testing/animation/bottomAnimation.dart';

class OrderAdmin extends StatefulWidget {
  @override
  _OrderAdminState createState() => _OrderAdminState();
}

class _OrderAdminState extends State<OrderAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: Text(
          "Orders",
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
                child: Text("No Order Placed!"),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return WidgetAnimator(
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                            "Payment ID: " +
                                snapshot.data[index]['pID'].toString(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("\nUser ID: " +
                                snapshot.data[index]['pForeignUserID']
                                    .toString()),
                            Text("Art ID: " +
                                snapshot.data[index]['artIDFK'].toString()),
                          ],
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _delete(snapshot.data[index]['pID']);
                              });
                            }),
                      ),
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
    );
  }

  final dbHelper = DatabaseHelper.instance;

  Future _query() async {
    final allRows = await dbHelper.queryAllPayments();
    return allRows;
  }

  void _delete(int paymentID) async {
    await dbHelper.deleteOrder(paymentID);
  }
}
