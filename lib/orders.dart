import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:splashdelivery/api.dart';
class orders extends StatefulWidget {
  const orders({Key? key}) : super(key: key);

  @override
  State<orders> createState() => _ordersState();
}

class _ordersState extends State<orders> {
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
                                    Text(element['userMobile'].toString()),
                                    //pleaser show all other attributes look at firestore


                                    ElevatedButton(onPressed: ()async{
                                      final data = {"uid":element['uid'].toString(),"userName": element['userName'].toString(), "userMobile":element['userMobile'].toString(),"userAddress":element['userAddress'].toString(),"status":"Delivery Person Will Pickup Soon.","baggageNumber":"" };
                                      common.sentFirebase(data, 'approvedOrder');
                                      common.deleteFirebase(element.reference.id,'request');
                                      setState(() { });
                                    }, child: const Text("Accept")),


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
