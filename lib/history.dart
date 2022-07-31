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
  List<Widget> listWidget=[];
  String baggageNumber="Baggage Number";
  api common=api();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Splash Delivery"),
      ),
      body: Center(
          child:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("request").get().asStream(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        listWidget.clear();
                        snapshot.data?.docs.forEach((element) {
                          listWidget.add(
                              Container(

                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Text(element['userName'].toString()),
                                    Text(element['userAddress'].toString()),
                                    Text(element['userPhone'].toString()),
                                    //pleaser show all other attributes look at firestore


                                    ElevatedButton(onPressed: ()async{
                                      String barCode="69998";
                                       barCode=await FlutterBarcodeScanner.scanBarcode(
                                          "#ff6666", "Cancel", false, ScanMode.DEFAULT);
                                       print("Barcode is $barCode");
                                       print("Document is "+element.reference.id);


                                      final data = {"baggageNumber":barCode.toString() };
                                      common.updateFirebase(element.reference.id, data, 'request');
                                      showToastWidget(Text('Baggage Number Addedd Succefully'));



                                      setState(() { });
                                    }, child: const Text("Scan Qr code")),
                                    ElevatedButton(onPressed: ()async{
                                      final data = {"status":"Waiting For Wash.","baggageNumber":element['baggageNumber'].toString() };

                                      common.updateFirebase(element.reference.id,data, 'request');
                                      setState(() { });
                                    }, child: const Text("Delivered")),

                                  ElevatedButton(onPressed: ()async{
                                    final data = {"status":"Delivery Person Will Pickup Soon.",};
                                      common.updateFirebase(element.reference.id,data, 'request');

                              setState(() { });
                            }, child: Text("Accept")),


                                  ],
                                ),
                              )
                          );
                        });
                        return Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: (ListView(children:listWidget)));
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error_outline);
                      } else {
                        return CircularProgressIndicator();
                      }
                    })

              ],
            ),
          )
      ),
    );
  }
}
