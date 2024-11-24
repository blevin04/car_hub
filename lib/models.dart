import 'package:car_hub/backendFxns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  final String email;
  final String uid;
  UserModel({
    required this.fullName,
    required this.email,
    required this.uid,
  });

// toJson

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "uid": uid,
      };
}
class roomModel{
  final String roomName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final DateTime creationTime;
  final List admins;
  final String description;
  final bool isprivate;
  roomModel({
    required this.roomName,
    required this.lastMessage,
    required this.admins,
    required this.creationTime,
    required this.lastMessageTime,
    required this.description,
    required this.isprivate,
  });
  Map<String,dynamic> toJson() =>{
    "Name":roomName,
    "lastMessage":lastMessage,
    "lastMessageTime":lastMessageTime,
    "Admins":admins,
    "creationTime":creationTime,
    "members":[user!.uid],
    "description":description,
    "isprivate":isprivate
  };
}

class messageModel{
  final String message;
  final DateTime time;
  final bool seen;
  final String media;
  messageModel({
    required this.message,
    required this.time,
    required this.seen,
    required this.media,
    
  });

  Map<String,dynamic> toJson()=>{
    "message": message,
    "Time":time,
    "Seen":seen,
    "type":media,
    "sender":user!.uid,
  };
}