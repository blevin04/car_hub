import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:car_hub/categories.dart';
import 'package:car_hub/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance.ref();
final model =
      FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash');
User? user = FirebaseAuth.instance.currentUser;
Future<Map<dynamic,dynamic>> getUserData()async{
    Map<dynamic,dynamic> data = {};
  await Hive.openBox("UserData");
  Box userbox = Hive.box("UserData");
  if (userbox.isNotEmpty) {
    return userbox.toMap();
  }
  user ??= FirebaseAuth.instance.currentUser;
  await firestore.collection("users").doc(user!.uid).get().then((onValue){
    data = onValue.data()!;
  });
  userbox.putAll(data);
  return data;
}
Future<String> getFact()async{
String fact = "";
  await Hive.openBox("Facts");
  // print(DateTime.now().difference(Hive.box("Facts").get("Data").first));
  if(Hive.box("Facts").isEmpty)
  {
    
    try{
      final prompt = [Content.text('Generate a single random car fact ')];
// To generate text output, call generateContent with the text input
    final response = await model.generateContent(prompt);
      fact = response.text!;

    final factdata = {
      "Data":[DateTime.now(),fact]
    };
    Hive.box("Facts").putAll(factdata);
    }catch(e){
      print(e.toString());
      fact = "";
    }
    
  }else{
    if (DateTime.now().difference(Hive.box("Facts").
  get("Data").first)>=const Duration(days: 1)) {
      try{
      // Provide a prompt that contains text
final prompt = [Content.text('Generate a single random car fact ')];
// To generate text output, call generateContent with the text input
final response = await model.generateContent(prompt);
fact = response.text!;
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
  // Provide a prompt that contains text
  try {
    final prompt = [Content.text("Generate ten questions questions should be about cars and the car community.Put them in a map format with keys being string from 0 to 9 and value be a map of key question with the question as the value and key choice with the list 4 choices as the value then key answer with the answer as the value.make all keys strings note: dont add any unncessesary information like example usage ")];
  final responce = await model.generateContent(prompt);
  
  
  
    // var values = responce.text!.replaceAll(RegExp(r"`"), " ").replaceAll(RegExp(r"python"), " ").replaceAll(RegExp(r"import json"), " ");
    
    var values = responce.text!.replaceAll(RegExp(r"0"), "0").replaceAll(RegExp(r"`"), " ").replaceAll(RegExp(r"python"), " ").replaceFirst(RegExp("car_questions = "), " ");
      var check  = jsonDecode(values);
    //triviaQuiz = values[0]
    print(check);
    triviaQuiz = check;
    // print(triviaQuiz);
  } catch (e) {
    print(e.toString());
  }

 
  return triviaQuiz;
}
Future<double> getScore(int gameNum )async{
  double score = 0;
  await Hive.openBox("Score");
  if (FirebaseAuth.instance.currentUser != null) {
     if ( !await InternetConnection().hasInternetAccess) {
    if (gameNum == 0) {
      await Hive.openBox("Score");
      score = Hive.box("Score").get("RevWaveScore");
    }
    if (gameNum == 1) {
      await Hive.openBox("Score");
    score =Hive.box("Score").get("TriviaScore");

    }
  }else{
   
    if (gameNum == 0) {
      
      await firestore.collection("users").doc(user!.uid).get().then((onValue){
        if (onValue.data()!.containsKey("RevWaveScore")) {
          score = onValue.data()!["RevWaveScore"];
          UpdateHighScore(score,gameNum);
        }
      });
    }
    if (gameNum == 1) {
      
    await firestore.collection("users").doc(user!.uid).get().then((onValue){
      if (onValue.data()!.containsKey("TriviaScore")) {
        
          score = onValue.data()!["TriviaScore"].toDouble();
        
        UpdateHighScore(score,gameNum);
      }
    });

    }
  }
  }
 
  return score;
}
Future<String>UpdateHighScore(double score,int gameNum)async{
  String state = "";
  String game = gameNum == 0? "RevWaveScore": gameNum == 1? "TriviaScore":"default";
await Hive.openBox("Score");
if (Hive.box("Score").containsKey(game)) {
  print("00000");
  if (Hive.box("Score").get(game)<score) {
    print("11111111");
  try {
     await firestore.collection("users").doc(user!.uid).update({game:score});
     
     Hive.box("Score").put(game, score);
     state = "Success";
  } catch (e) {
    state = e.toString();
  }
}
}else{
  try {
    print("2222222222");
     await firestore.collection("users").doc(user!.uid).get().then((onValue)async{
      if (onValue.data()!.containsKey(game)) {
        print("wwwwwwwwwww");
        if (onValue.data()![game]>score) {
          print("rrrrrrrrrrrr");
          Hive.box("Score").put(game, onValue.data()![game]);
        }else{
          print("llllllllllllll");
          await firestore.collection("users").doc(user!.uid).update({game:score});
          Hive.box("Score").put(game, score);
        }
      }else{
        await firestore.collection("users").doc(user!.uid).update({game:score});
        Hive.box("Score").put(game, score);
      }
     });
     
     
     state = "Success";
  } catch (e) {
    state = e.toString();
  }
}
print(state);
  return state;
}

Future<List> getrooms()async{
  List rooms =List.empty(growable: true);
  await Hive.openBox("Rooms");
  if (Hive.box("Rooms").isEmpty) {
    user ??= FirebaseAuth.instance.currentUser;
    // print("ppppppp");
    await firestore.collection("rooms").where("members",arrayContains: user!.uid).get().then((onValue){
      // print(onValue.docs.length);
      for(var doc in onValue.docs){
        rooms.add(doc.id);
      }
    });
    await Hive.box("Rooms").put("Rooms", rooms);
    // print(Hive.box("tt").isOpen);
    // print(".//////////////////");
  }else{
    // print("||||||||||||||||||||||||||");
    rooms = Hive.box("Rooms").get("Rooms");
    // print(rooms);
    //  Hive.box("Rooms").clear();
  }
  checkSubscription(rooms);
  // print(Hive.box("tt").isOpen);
  // print(rooms.length);
  return rooms;
}
void checkSubscription(List rooms)async{
  await Hive.openBox("subscriptions");
  if (Hive.box("subscriptions").containsKey("subscribed")) {
    // print(".................${Hive.box("subscriptions").get("subscribed")}");
    List subscribed = Hive.box("subscriptions").get("subscribed");
    for(var room in rooms){
    if (!subscribed.contains(room)) {
    await FirebaseMessaging.instance.subscribeToTopic(room);
    subscribed.add(room);
    }
  }
  Hive.box("subscriptions").put("subscribed", subscribed);
  }else{
    for(var room in rooms){
    await FirebaseMessaging.instance.subscribeToTopic(room);
  }
  Hive.box("subscriptions").put("subscribed", rooms);
  }
  
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
      isprivate: public,
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
Future<String>sendMessage(String messagetext,String roomId,String media,[String mediaPath = ""])async{
  String state = "";
  String messageId = Uuid().v1();
  try {
    messageModel message = messageModel(
      message: messagetext, 
      time: DateTime.now(), 
      seen: false, 
      media: media,
      );
    await firestore.collection("rooms").doc(roomId).collection("messages").doc(messageId).set(message.toJson());
    if (mediaPath.isNotEmpty) {
      String mediaN = mediaPath.split("/").last;
      await storage.child("messages/$roomId/$messageId/$mediaN").putFile(File(mediaPath));
    }
    state = "Success";
  } catch (e) {
    state = e.toString();
  }
  // print(state);
  return state;
}
StreamController controller = StreamController();

Future<Map<dynamic,dynamic>> getroominFo(String roomId)async{
  // print("////////////////////////////// $roomId");
  Map<dynamic,dynamic>info = {};
  await Hive.openBox(roomId);
  Hive.box(roomId).clear();
  try {
    if (Hive.box(roomId).isEmpty) {
      await firestore.collection("rooms").doc(roomId).get().then((onValue){
        
        info = onValue.data()!;
        // print(info);
      });
      //  Hive.box(roomId).putAll(info);
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
  // print(".................................");
  // print(state);
  return state;
}
Future<Uint8List> getWallpaper(String id)async{
  // String state = "";
  Uint8List wallpaper = Uint8List(100);
  try {
    await storage.child("/wallpapers/$id").list().then((onValue)async{
      wallpaper =(await onValue.items.single.getData())!;
    });
    // state = "Success";
  } catch (e) {
    // state = e.toString();
  }
  return wallpaper;
}
Future<ImageProvider> getCoverPic()async{
  Uint8List dp = Uint8List(100);
  ImageProvider img;
  Box usbox = Hive.box("UserData");
  try {
    if (usbox.containsKey("cover")) {
    dp = usbox.get("cover");
    //img = MemoryImage(dp);
  }else{
    await storage.child("users/${user!.uid}/cover").list().then((onValue)async{
      dp = (await (onValue.items.single.getData()))!;
      usbox.put("cover", dp);
      //img = MemoryImage(dp);
    });
  }
  img = MemoryImage(dp);
  } catch (e) {
    img =const AssetImage("lib/assets/default_cover.png");
  }
  
  return img;
}

Future<ImageProvider> getDp()async{
  Uint8List dp = Uint8List(100);
  ImageProvider img;
  Box usbox = Hive.box("UserData");
  try {
    if (usbox.containsKey("Dp")) {
    dp = usbox.get("Dp");
    //img = MemoryImage(dp);
  }else{
    await storage.child("users/${user!.uid}/dp").list().then((onValue)async{
      dp = (await (onValue.items.single.getData()))!;
      usbox.put("Dp", dp);
      //img = MemoryImage(dp);
    });
  }
  img = MemoryImage(dp);
  } catch (e) {
    img =const AssetImage("lib/assets/default_profile.webp");
  }
  
  return img;
}

Future<String> setcover(String imagePath)async{
  String state = "";
  try {
    String imgName = imagePath.split("/").last;
    await storage.child("/users/${user!.uid}/cover/$imgName").putFile(File(imagePath));
    
    Uint8List cover =await File(imagePath).readAsBytes();
    Hive.box("UserData").put("cover", cover);
    state = "Success";
  } catch (e) {
    state = e.toString();
  }
  return state;
}

Future<String> setDp(String imagePath)async{
  String state = "";
  try {
    String imgName = imagePath.split("/").last;
    await storage.child("/users/${user!.uid}/dp/$imgName").putFile(File(imagePath));
    Uint8List cover =await File(imagePath).readAsBytes();
    Hive.box("UserData").put("Dp", cover);
    state = "Success";
  } catch (e) {
    state = e.toString();
  }
  return state;
}
Future<String>setName(String newName)async{
  await firestore.collection("users").doc(user!.uid).update({"fullName":newName});
  Hive.box("UserData").put("fullName", newName);
  return "Success";
}

Future<String>UploadAudio(String audioPath,String name,List categories,List more)async{
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
    categoryNames.addAll(more);
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

Future<List<QueryDocumentSnapshot>> getTunes()async{
  List<QueryDocumentSnapshot> tunes = [];
  await firestore.collection("tunes").where("name",isNotEqualTo: null).get().then((onValue){
    for(var value in onValue.docs){
      tunes.add(value);
    }
  });
  return tunes;
}
Map<String,dynamic> catchedTunes = {};
Future<Uint8List>gettuneData(String tuneId)async{
  if(catchedTunes.containsKey(tuneId)){
    return catchedTunes[tuneId];
  }else{
    Uint8List data = Uint8List(100);
  await storage.child("tunes/$tuneId").list().then((onValue)async{
    data = (await onValue.items.single.getData())!;
  });
  catchedTunes.addAll({tuneId:data});
  return data;
  }
  
}

Future<List<QueryDocumentSnapshot>> getWallpaperIds({String filter= ""})async{
  List<QueryDocumentSnapshot> wallpapers = [];
  try {
    if (filter.isEmpty) {
      await firestore.collection("wallpapers").where("name",isNotEqualTo: null).get().then((onValue){
      wallpapers = onValue.docs;
    });
    }
  } catch (e) {
    throw e.toString();
  }
  return wallpapers;
}

void likeContent(String content,String contentId)async{
  List likes = [];
  await firestore.collection(content).doc(contentId).get().then((onValue){
    likes = onValue.data()!["Likes"];
  });
  if (likes.contains(user!.uid)) {
    likes.remove(user!.uid);
  }else{
    likes.add(user!.uid);
  }
  await firestore.collection(content).doc(contentId).update({"Likes":likes});
}

List<QueryDocumentSnapshot> publicr = [];
Future<List<QueryDocumentSnapshot>> searchPublic(String filter)async{
  List<QueryDocumentSnapshot> rooms = [];
  if (publicr.isEmpty) {
    await firestore.collection("rooms").where("isprivate",isEqualTo: false).get().then((onValue){
      //print(onValue.doc)
    for(var room in onValue.docs){
      publicr.add(room);
      if (room.data()["Name"].toLowerCase().contains(filter.toLowerCase())) {
        rooms.add(room);
      }
    }
  });
  }else{
    for(var public in publicr){
      if (public["Name"].toLowerCase().contains(filter.toLowerCase())) {
        rooms.add(public);
      }
    }
  }
for(var room in rooms){
  Map data = room.data()! as Map;
  if (data["members"].contains(user!.uid)) {
    rooms.remove(room);
  }
}
return rooms;
}

Future<Map<String,dynamic>>getMembersdata(List members)async{
  Map<String,dynamic> data = {};
  for(var id in members){
    await firestore.collection("users").doc(id).get().then((onValue){
      final dt =<String,dynamic> {id:onValue.data()!["fullName"]};
      data.addAll(dt);
    });
  }
  return data;
}

Future<Uint8List>getMessageMedia(String messageId,String roomId)async{
  Uint8List media = Uint8List(100);

  await storage.child("messages/$roomId/$messageId/").list().then((onValue)async{
    // print(onValue.items.length);
    media = (await onValue.items.single.getData() )!;
  });

  return media;
}
Future<Map<String,dynamic>> preGame()async{
Map<String,dynamic> gameMap = {};

await firestore.collection("tunes").get().then((onValue)async{
  List tuneData = onValue.docs.toList();
  tuneData.shuffle();
  List sequence = [];
  while (sequence.length<5) {
    int newN = Random().nextInt(tuneData.length);
    if (!sequence.contains(newN)) {
      print("sssssssssssssss$sequence");
      sequence.add(newN);
    }
  }
  // List sequence = List.generate((5), (index){
  //   return Random().nextInt(tuneData.length);
  // });
  // List master = [];
  // List repeated = [];
  // for (var i = 0; i < sequence.length; i++) {
  //   if(master.contains(sequence[i])){
  //     repeated.add(sequence[i]);
  //   }else{
  //     master.add(sequence[i]);
  //   }
  // }
  
  // print("lllllllllllllllllls$sequence");
  for (var i = 0; i < sequence.length; i++) {
    Map<String,dynamic> dataAll = tuneData[sequence[i]].data();
    await storage.child("tunes/${tuneData[sequence[i]].id}").list().then((onValueM)async{
      Uint8List?  mp3Data = await onValueM.items.single.getData();
      
      dataAll.addAll({"MP3":mp3Data!});
    });
    gameMap.addAll({tuneData[sequence[i]].id:dataAll});
  }
  //  sequence.forEach((index)async{
    
  // });

});
// Map mp3Map = {};
// gameMap.forEach((key,value)async{
//   await storage.child("/tunes/$key").list().then((onValue)async{
    
//     Uint8List? mp3data = await onValue.items.single.getData();
//     mp3Map.addAll({key:mp3data!});
//   });
// });
// print("nnnnnnnnnnnnnnnnnnn${mp3Map.length}");
// mp3Map.forEach((key,value){
//   Map data0 = gameMap[key];
//   data0.addAll({"MP3":value});
//   gameMap.update(key, (data)=>data0);
// });
// print(gameMap.keys);
return gameMap;
}