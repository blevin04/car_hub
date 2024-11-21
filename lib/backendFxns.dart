import 'dart:convert';

import 'package:car_hub/models.dart';
import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

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
  print(DateTime.now().difference(Hive.box("Facts").get("Data").first));
  if(Hive.box("Facts").isEmpty||DateTime.now().difference(Hive.box("Facts").
  get("Data").first)>=const Duration(days: 1))
  {
    try{
      await gemini.text("random car fact").then((onValue){
      fact = onValue!.output!;
    });
    final factdata = {
      "Data":[DateTime.now(),fact]
    };
    Hive.box("Facts").putAll(factdata);
    }catch(e){
      fact = "";
    }
    
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

Future<String>UpdateHighScore(double score)async{
  String state = "";
await Hive.openBox("Score");
if (Hive.box("Score").containsKey("CarTrivia")) {
  if (Hive.box("Score").get("CarTrivia")<score) {
  try {
     await firestore.collection("users").doc(user!.uid).update({"Score":score});
     
     Hive.box("Score").put("CarTrivia", score);
     state = "Success";
  } catch (e) {
    state = e.toString();
  }
}
}else{
  try {
     await firestore.collection("users").doc(user!.uid).update({"Score":score});
     
     Hive.box("Score").put("CarTrivia", score);
     state = "Success";
  } catch (e) {
    state = e.toString();
  }
}
  return state;
}

Future<List<String>> getrooms()async{
  List<String>rooms =List.empty(growable: true);
  await Hive.openBox("Rooms");
  if (Hive.box("Rooms").isEmpty) {
    await firestore.collection("rooms").where("members",arrayContains: user!.uid).get().then((onValue){
      for(var doc in onValue.docs){
        rooms.add(doc.id);
      }
    });
    await Hive.box("Rooms").put("Rooms", rooms);
  }else{
    rooms = Hive.box("Rooms").get("Rooms");
  }

  return rooms;
}

Future<String> joinroom(String room)async{
  String state ="";
  await Hive.openBox("Rooms");
  try {
     await firestore.collection("rooms").doc(room).get().then((onValue)async{
      List members = onValue.data()!["members"];
      members.add(user!.uid);
      await firestore.collection("rooms").doc(room).update({"members":members});
      List rooms = Hive.box("Rooms").get("Rooms");
      rooms.add(room);
      await Hive.box("Rooms").put("Rooms", rooms);
     });
     state = "Success";
  } catch (e) {
    state = e.toString();
  }
  return state;
}

Future<String> createRoom(String roomName,bool public,String description,)async{
  String state = "";
  String roomId = Uuid().v1();
  String name =Hive.box("UserData").get("fullName");
  await Hive.openBox("Rooms");
  try {
    roomModel roomD = roomModel(
      roomName: roomName, 
      lastMessage: "$name created $roomName",
       admins: [user!.uid], 
       creationTime: DateTime.now(), 
       lastMessageTime: DateTime.now());
    await firestore.collection("rooms").doc(roomId).set(roomD.toJson());
    List room0 = Hive.box("Rooms").get("Rooms");
    room0.add(roomId);
    await Hive.box("Rooms").put("Rooms", room0);
    state = "Success";
  } catch (e) {
    state = e.toString();
  }
  return state;
}
Future<String>sendMessage(String messagetext,String roomId,MessageType media)async{
  String state = "";
  String messageId = Uuid().v1();
  try {
    messageModel message = messageModel(
      message: messagetext, 
      time: FieldValue.serverTimestamp(), 
      seen: false, 
      media: media,

      );
    await firestore.collection("rooms").doc(roomId).collection("messages").doc(messageId).set(message.toJson());
    state = "Success";
  } catch (e) {
    state = e.toString();
  }
  return state;
}

Future<Map<dynamic,dynamic>> getroominFo(String roomId)async{
  Map<dynamic,dynamic>info = {};
  await Hive.openBox(roomId);
  try {
    if (Hive.box(roomId).isEmpty) {
      await firestore.collection("rooms").doc(roomId).get().then((onValue){
        info = onValue.data()!;
      });
      await Hive.box(roomId).putAll(info);
          }else{
            info = Hive.box(roomId).toMap();
          }
          
  } catch (e) {
    throw e.toString();
  }

  return info;
}


// Future<Map<String,dynamic>> getChat(String roomId)async{
//   Map<String,dynamic> chatData = {};

//   await firestore.collection("rooms").doc(roomId).collection("messeges").orderBy("time",descending: false).limit(30).get().then((onValue){
//     for(var doc in onValue.docs){
//       final data = {doc.id:doc.data()};
//       chatData.addAll(data);
//     }
//   });
//   return chatData;
// }