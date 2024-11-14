
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';

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