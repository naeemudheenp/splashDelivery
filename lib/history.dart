import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:oktoast/oktoast.dart';
import 'package:splashdelivery/api.dart';

class history extends StatefulWidget {
  const history({Key? key}) : super(key: key);

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  List<Widget> listWidget = [];
  String baggageNumber = "Baggage Number";
  api common = api();
  bool _orderTaken = false;
  bool _scanQR = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Splash Delivery"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("request")
                    .get()
                    .asStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    listWidget.clear();
                    snapshot.data?.docs.forEach((element) {
                      listWidget.add(
                          //New
                          Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: .8,
                                //  spreadRadius: 0.1,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                              ),
                              child: Text(element['userName'].toString()),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(element['userAddress'].toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              child: Text(element['userPhone'].toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //Scanning button only appears if Order is accepted
                                  if (_orderTaken == true)
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: _orderTaken
                                              ? Colors.blueAccent
                                              : Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )),
                                      onPressed: () {
                                        setState(() {
                                          final data = {
                                            "status": "Waiting For Wash.",
                                            "baggageNumber":
                                                element['baggageNumber']
                                                    .toString()
                                          };

                                          common.updateFirebase(
                                              element.reference.id,
                                              data,
                                              'request');
                                        });
                                      },
                                      child: const Text('Scan QR'),
                                    ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: _orderTaken
                                            ? Colors.blueAccent
                                            : Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    onPressed: () {
                                      setState(() {
                                        if (_orderTaken = false) {
                                          final data = {
                                            "status":
                                                "Delivery Person Will Pickup Soon.",
                                          };
                                          common.updateFirebase(
                                              element.reference.id,
                                              data,
                                              'request');
                                        }

                                        if (_orderTaken) {
                                          final data = {
                                            "status": "Waiting For Wash.",
                                            "baggageNumber":
                                                element['baggageNumber']
                                                    .toString()
                                          };

                                          common.updateFirebase(
                                              element.reference.id,
                                              data,
                                              'request');
                                        }

                                        _scanQR = true;
                                        //  _orderTaken = !_orderTaken;
                                        /* _orderTaken
                                    ? Colors.blueAccent
                                    : Colors.green, */
                                      });
                                      _orderTaken = !_orderTaken;
                                    },
                                    child: Text(
                                        _orderTaken ? 'Delivered' : "Accept"),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));

                      //Old
                    });
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: (ListView(children: listWidget)));
                  } else if (snapshot.hasError) {
                    return Icon(Icons.error_outline);
                  } else {
                    return CircularProgressIndicator();
                  }
                })
          ],
        ),
      )),
    );
  }
}
