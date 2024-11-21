import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/utils.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyWidget extends StatelessWidget {
  final String roomId;
  final String roomName;
  final Map<String,dynamic> info;
  const MyWidget({super.key,required this.roomId,required this.roomName,required this.info});
  static String uName = Hive.box("UserData").get("fullName");
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(),
        title: Text(roomName),
      ),
      endDrawer:Drawer(),
      body: StreamBuilder(
        stream: firestore.collection("rooms").doc(roomId).collection("messages").orderBy("time",descending: false).limit(30).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.data.isEmpty) {
            return const Center(child: Text("Be first to send a message"),);
          }
          List members = info["members"];
          return 
               ChatView(
                loadingWidget:const CircularProgressIndicator(),
                onSendTap: (message, replyMessage, messageType) {
                  sendMessage(message, roomId, messageType);
                },
                chatViewState: ChatViewState.hasMessages,
                chatController: ChatController(
                  initialMessageList: List.generate(30, (index){
                    MessageType type = snapshot.data[index]["type"];
                    String textM = snapshot.data[index]["message"];
                    String sender = snapshot.data[index]["sender"];
                    bool seen = snapshot.data[index]["seen"];
                    DateTime time = snapshot.data[index]["time"].toDate();
                    
                    return Message(
                      messageType: type,
                      message: textM, 
                      createdAt: time, 
                      sentBy: sender
                      );
                  }), 
                  scrollController: ScrollController(), 
                  otherUsers: List.generate(members.length, (index){
                    return ChatUser(
                      id: members[index], 
                      name:"user",

                      );
                  }), 
                  currentUser: ChatUser(id: user!.uid, name: uName)),);
           
        },
      ),
    );
  }
}