import 'package:car_hub/backendFxns.dart';
import 'package:flutter/material.dart';

showsnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

String duration(DateTime time){
  String timeS = "";
  if (time.difference(DateTime.now()).inDays>0) {
    timeS = time.difference(DateTime.now()).inDays.toString();
  }else if(time.difference(DateTime.now()).inHours>0){
    timeS = time.difference(DateTime.now()).inHours.toString();
  }else if(time.difference(DateTime.now()).inMinutes>1){
    timeS = time.difference(DateTime.now()).inMinutes.toString();
  }else if(time.difference(DateTime.now()).inSeconds>1){
    timeS = time.difference(DateTime.now()).inSeconds.toString();
  }
  return timeS;
}
Future<String> getUserName(String userId)async{
  String nameU = "";
  await firestore.collection("users").doc(userId).get().then((onValue){
    nameU = onValue.data()!["fullName"];
  });
  return nameU;
}