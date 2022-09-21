import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:oktoast/oktoast.dart';
import 'package:splashdelivery/api.dart';

import 'job.dart';
import 'openScanner.dart';

class history extends StatefulWidget {
  const history({Key? key}) : super(key: key);

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  List<Widget> listWidget = [];
  String baggageNumber = "Baggage Number";
  api common = api();

  List _orderbuttonStatus=[false,false,false,false,false,false,false,false,false,false,false,];
  List _scanbuttonStatus=[false,false,false,false,false,false,false,false,false,false,false,];
  int count=0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Splash Delivery"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[400],
        actions: [
          IconButton(onPressed: () async{
            String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                "#ff6666", "Cancel", false, ScanMode.DEFAULT);
            common.sentPref('baggageNumber', barcodeScanRes);
            common.gotoPage(job(), context);
          }, icon: Icon(Icons.qr_code_scanner))
        ],
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("request")
                    .where("delRequest",isEqualTo: 0)
                    .get()
                    .asStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {


                    listWidget.clear();
                    snapshot.data?.docs.forEach((element) {




                      print(count);

                      listWidget.add(
                          //New
                          Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Container(
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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blueGrey[400],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          )),
                                      onPressed: () async{
                                        setState(() async {
                                          String barCode="69998";
                                          barCode=await FlutterBarcodeScanner.scanBarcode(
                                              "#ff6666", "Cancel", false, ScanMode.DEFAULT);



                                          final data = {"baggageNumber":barCode.toString() };
                                          common.updateFirebase(element.reference.id, data, 'request');
                                          showToastWidget(Text('Baggage Number Addedd Succefully'));



                                          setState(() { });
                                        });
                                      },
                                      child: const Text('Scan QR'),
                                    ),



                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: _orderbuttonStatus[count]
                                              ? Colors.blueAccent
                                              : Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          )),
                                      onPressed: () {
                                        setState(() {



                                            final data = {
                                              "status":
                                              "Delivery Person Will Pickup Soon.",
                                            };
                                            common.updateFirebase(
                                                element.reference.id,
                                                data,
                                                'request');
                                          });}


                                      ,
                                      child: Text(
                                          "Accept"),
                                    ),








                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: _orderbuttonStatus[count]
                                              ? Colors.blueAccent
                                              : Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          )),
                                      onPressed: () {
                                        setState(() {
                                          _scanbuttonStatus[count] = true;



                                            final data = {
                                              "status": "Waiting For Wash.",
                                              "baggageNumber":
                                              element['baggageNumber']
                                                  .toString(),
                                              "delRequest":1
                                            };
                                            common.updateFirebase(
                                                element.reference.id,
                                                data,
                                                'request');




                                        });
                                      },
                                      child: Text(
                                           'Delivered'),
                                    ),
















                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
                      count=count+1;
                      //Old
                    });
                    print(_orderbuttonStatus);
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: (Column(children: listWidget)));
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
