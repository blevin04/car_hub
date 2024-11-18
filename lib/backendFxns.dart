import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';

final gemini = Gemini.instance;
final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance.ref();
User? user = FirebaseAuth.instance.currentUser;
Future<Map<dynamic,dynamic>> getUserData()async{
    Map<dynamic,dynamic> data = {};
  await Hive.openBox("UserData");
  Box userbox = Hive.box("UserData");
  if (userbox.isNotEmpty) {
    return userbox.toMap();
  }
  await firestore.collection("users").doc(user!.uid).get().then((onValue){
    data = onValue.data()!;
  });
  userbox.putAll(data);
  return data;
}
Future<String> getFact()async{
String fact = "";
  await Hive.openBox("Facts");
  if(Hive.box("Facts").isEmpty||DateTime.now().difference(Hive.box("Facts").
  get("Data").first)>=const Duration(days: 1))
  {
    await gemini.text("random car fact").then((onValue){
      fact = onValue!.output!;
    });
    final factdata = {
      "Data":[DateTime.now(),fact]
    };
    Hive.box("Facts").putAll(factdata);
  }else{
    fact = Hive.box("Facts").get("Data").last;
  }
return fact;
}
Future<Map<dynamic,dynamic>> triviaStart()async{
  Map<dynamic,dynamic> triviaQuiz = {};
  //int questionNo = 0;
  await gemini.text("Generate ten questions questions should be about cars and the car community.Put them in a map format with keys being string from 0 to 9 and value be a map of key question with the question as the value and key choice with the list 4 choices as the value then key answer with the answer as the value.make all keys strings").
  then((onValue){
    var values = onValue!.output!.replaceAll(RegExp(r"`"), " ");
    values.replaceAll(RegExp(r"0"), "0");
      var check  = jsonDecode(values);
    //triviaQuiz = values[0]
    print(check);
    triviaQuiz = check;
    print(triviaQuiz);
  });
  return triviaQuiz;
}