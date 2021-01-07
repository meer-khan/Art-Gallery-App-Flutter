import 'package:flutter/material.dart';
import 'package:testing/Database/database.dart';

class PaymentPage extends StatefulWidget {
  final int artID;
  final int userID;
  final Function(bool) callback;
  PaymentPage({this.artID, this.userID, this.callback});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

final ccNumberCont = TextEditingController();
final pinCont = TextEditingController();
final addressCont = TextEditingController();
final cityCont = TextEditingController();
final phoneCont = TextEditingController();

class _PaymentPageState extends State<PaymentPage> {
  String _radioValue;
  String choice;

  void _radioButtonPress(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'MasterCard':
          choice = value;
          break;
        case 'VISA':
          choice = value;
          break;
        default:
          choice = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Payment",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 3.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "PAYMENT DETAILS",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: ccNumberCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Credit Card Number'),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: pinCont,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Pin',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: addressCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Address'),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: cityCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'City'),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Select Card",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: "MasterCard",
                    groupValue: _radioValue,
                    onChanged: _radioButtonPress,
                  ),
                  Text("Master Card"),
                  SizedBox(
                    width: 100,
                  ),
                  Radio(
                    value: "VISA",
                    groupValue: _radioValue,
                    onChanged: _radioButtonPress,
                  ),
                  Text("VISA")
                ],
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: FlatButton(
                  color: Colors.orange,
                  shape: StadiumBorder(),
                  onPressed: () {
                    insertPaymentOrder();
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child:
                      const Text('Place Order', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  clearController() {
    ccNumberCont.clear();
    pinCont.clear();
    addressCont.clear();
    cityCont.clear();
  }

  final dbHelper = DatabaseHelper.instance;
  void insertPaymentOrder() async {
    await dbHelper.insertPaymentOrder(
        widget.artID,
        widget.userID,
        ccNumberCont.text,
        _radioValue,
        pinCont.text,
        addressCont.text,
        cityCont.text);
    clearController();
    FocusScope.of(context).unfocus();
    widget.callback(true);
    Navigator.pop(context);
  }
}
