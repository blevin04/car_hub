import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:car_hub/categories.dart';
import 'package:car_hub/models.dart';
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
  //print(DateTime.now().difference(Hive.box("Facts").get("Data").first));
  if(Hive.box("Facts").isEmpty)
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
    if (DateTime.now().difference(Hive.box("Facts").
  get("Data").first)>=const Duration(days: 1)) {
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
      description: description,
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
Future<String>sendMessage(String messagetext,String roomId,String media)async{
  String state = "";
  String messageId = Uuid().v1();
  try {
    messageModel message = messageModel(
      message: messagetext, 
      time: FieldValue.serverTimestamp(), 
      seen: false, 
      media: media,
      );
      print(message);
    await firestore.collection("rooms").doc(roomId).collection("messages").doc(messageId).set(message.toJson());
    state = "Success";
  } catch (e) {
    state = e.toString();
  }
  print(state);
  return state;
}

Future<Map<dynamic,dynamic>> getroominFo(String roomId)async{
  Map<dynamic,dynamic>info = {};
  await Hive.openBox(roomId);
  try {
    if (Hive.box(roomId).isEmpty) {
      await firestore.collection("rooms").doc(roomId).get().then((onValue){
        
        info = onValue.data()!;
        print(info);
      });
       Hive.box(roomId).putAll(info);
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

Future<String>uploadWallpaper(String path,String name)async{
  final store0 = FirebaseStorage.instance.ref();
String state = "";
  try {
    String imageId = Uuid().v1();
  await firestore.collection("wallpapers").doc(imageId).set({
    "owner":user!.uid,
    "downloads":0,
    "Likes":[],
    "name":name,
    "categories":[]
  });
  // await storage.child("/wallpapers/$imageId/wallpaper")
  String name0 = path.split("/").last;
   await store0.child("/wallpapers/$imageId/$name0").putFile(File(path));
  //await storage.child("/wallpapers").list().then((onValue){
  //   print(onValue.items);
  // });
  state = "Success";
  } catch (e) {
    state = e.toString();
  }
  print(".................................");
  print(state);
  return state;
}
Future<Uint8List> getWallpaper(String id)async{
  // String state = "";
  Uint8List wallpaper = Uint8List(100);
  try {
    await storage.child("/wallpapers/$id").getData().then((onValue){
      wallpaper = onValue!;
    });
    // state = "Success";
  } catch (e) {
    // state = e.toString();
  }
  return wallpaper;
}

Future<String> setDp(String imagePath)async{
  String state = "";
  try {
    await storage.child("/users/${user!.uid}/dp").putFile(File(imagePath));
    state = "Success";
  } catch (e) {
    state = e.toString();
  }
  return state;
}

Future<String>UploadAudio(String audioPath,String name,List categories)async{
  String state = "";
  try {
    String tuneId = Uuid().v1();
    List categoryNames = List.generate(categories.length, (index){
      if (index == 0){
        return engine_Size[categories[index]];
      }
      if (index == 1) {
        return brands[categories[index]];
      }
      return type[categories[index]];
    });
    await firestore.collection("tunes").doc(tuneId).set({
      "name":name,
      "downloads":0,
      "likes":[],
      "categories":categoryNames,

    });
    await storage.child("/tunes/$tuneId/$name").putFile(File(audioPath));
    state = "Success";
  } catch (e) {
    state = e.toString();
  }
  return state;
}