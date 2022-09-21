
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class api{
  void gotoPage(pageName,context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => pageName));
  }

  Future<bool> sentFirebase(data,collectionName)async{
    bool result= false;
    FirebaseFirestore db = FirebaseFirestore.instance;


    await db.collection(collectionName.toString()).add(data).then((documentSnapshot) =>
        result=true)
        .catchError((onError)=>
    print(onError.toString())
    );
    return result;
  }

  Future<bool> updateFirebase(documentName,data,collectionName)async{
    bool result= false;
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection(collectionName).doc(documentName).update(data).then((documentSnapshot) =>
    result=true)
        .catchError((onError)=>
        print(onError.toString())
    );
    return result;
  }

  Future<bool> sentPref(key,data)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
    return true;
  }

  Future<String> getPref(key)async{
    final prefs = await SharedPreferences.getInstance();

    return prefs.get(key).toString();
  }

  Future<bool> deleteFirebase(documentName,collectionName)async{
    bool result= false;
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection(collectionName).doc(documentName).delete();
    return result;
  }



}