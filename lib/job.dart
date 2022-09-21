import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'api.dart';
class job extends StatefulWidget {
  const job({Key? key}) : super(key: key);

  @override
  State<job> createState() => _jobState();
}

class _jobState extends State<job> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  List<String> _status = ["Pending", "Released", "Blocked"];
  String _singleValue = "Text alignment right";
  String _verticalGroupValue = "Pending";
  String baggaeNumber="";
  api common = api();
  List<Widget> listWidget=[];
  var items = [
    'Waiting For Wash',
    'Washing',
    'Ironing',
    'Waiting For Pickup',

  ];
  String dropdownvalue = 'Waiting For Wash';
  void initState() {
    getBaggage();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            child: Icon(Icons.refresh),
            onTap: (){
              onRefresh();
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("request").where("baggageNumber",isEqualTo: baggaeNumber).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (snapshot.hasData) {
                      listWidget.clear();
                      snapshot.data?.docs.forEach((element) {
                        bool isSoftwash=false;
                        bool isDrywash=false;
                        bool isNormalwash=false;



                       try {
                         isSoftwash=element.get('Soft Wash');
                       } catch (error) {
                           isSoftwash=false;
                       }

                       try {
                         isDrywash =element.get('Dry Wash');
                       } catch (error) {
                          isDrywash=false;
                       }

                       try {
                          isNormalwash=element.get('normalWash');
                       } catch (error) {
                          isNormalwash=false;
                       }



                        listWidget.add(

                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Wash Information",style: TextStyle(color: Colors.black,fontSize: 20)),
                                SizedBox(height: 10,),
                                Text('Name : '+element['userName'],style: TextStyle(color: Colors.black,fontSize: 20),),
                                SizedBox(height: 10,),
                                isDrywash?Text("Dry Wash Quantity :"+element['Dry Washqty'].toString(),style: TextStyle(color: Colors.black,fontSize: 20)):Text("Dry Wash :None",style: TextStyle(color: Colors.black,fontSize: 20)),
                                SizedBox(height: 10,),
                                isSoftwash?Text("Soft Wash Quantity :"+element['Soft Washqty'].toString(),style: TextStyle(color: Colors.black,fontSize: 20)):Text("Soft Wash :None",style: TextStyle(color: Colors.black,fontSize: 20)),
                                SizedBox(height: 10,),
                                isNormalwash?Text("Normal Wash Quantity :"+element['normalWashqty'].toString(),style: TextStyle(color: Colors.black,fontSize: 20)):Text("Normal Wash:None",style: TextStyle(color: Colors.black,fontSize: 20)),
                                SizedBox(height: 10,),



                              ],
                            ),
                          )

                        );

                      });
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: (Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: listWidget,)));
                    } else if (snapshot.hasError) {
                      return Icon(Icons.error_outline);
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  void getBaggage() async{
    baggaeNumber=await  common.getPref("baggageNumber");
    setState(() { });
  }

  void onRefresh() {

    setState(() {  });
  }

  void finishedWork(String refId) {
    var data={"status":"Completed.Waiting For Pickup"};
    common.updateFirebase(refId, data, "request");
    _btnController.success();

  }


}
