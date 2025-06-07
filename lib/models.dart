import 'package:car_hub/backendFxns.dart';

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

class collectionModel {
  final String uid;
  final List data;
  final String type;
  final String owner;
  final int pulls;
  collectionModel({
    required this.data,
    required this.owner,
    required this.type,
    required this.uid,
    required this.pulls,
  });

  Map<String,dynamic> toJson()=>{
    "uid":uid,
    "data":data,
    "type":type,
    "owner":owner,
    "pulls":pulls,
  };
}

//vehicle Model
class Vehicle {
  final String make;
  final String model;
  final double? barrels08;
  final int? city08;
  final int? comb08;
  final int? highway08;
  final int? fuelCost08;
  final String? fuelType;
  final String? trany;
  final String? year;
  final double? disp;
  final int? cylinders;
  final String? drive;
  final List? eng_dscr;
  Vehicle({
    required this.make,
    required this.model,
    required this.barrels08,
    required this.city08,
    required this.comb08,
    required this.highway08,
    required this.fuelCost08,
    required this.fuelType,
    required this.trany,
    required this.year,
    required this.cylinders,
    required this.disp,
    required this.drive,
    required this.eng_dscr,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      eng_dscr: json["eng_dscr"],
      drive: json["drive"],
      disp: json["disp"],
      cylinders: json["cylinders"],
      make: json['make'],
      model: json['model'],
      barrels08: json['barrels08']?.toDouble() ?? 0.0,
      city08: json['city08'] ?? 0,
      comb08: json['comb08'] ?? 0,
      highway08: json['highway08'] ?? 0,
      fuelCost08: json['fuelcost08'] ?? 0,
      fuelType: json['fueltype1'] ?? '',
      trany: json['trany'] ?? '',
      year: json['year'] ?? '',
    );
  }
}


