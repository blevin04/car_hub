import 'package:car_hub/backendFxns.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Room extends StatelessWidget {
  final String roomId;
  final String roomName;
  final Map<String,dynamic> info;
  const Room({super.key,required this.roomId,required this.roomName,required this.info});
  static String uName = Hive.box("UserData").get("fullName");
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(),
        ),
        title: Text(roomName),
      ),
      endDrawer:Drawer(),
      body: StreamBuilder(
        stream: firestore.collection("rooms").doc(roomId).collection("messages").orderBy("Time", descending: false).limit(30).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List members = info["members"];
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              String type = snapshot.data.docs[index]["type"];
              if (type == "image") {
                //return BubbleNormalImage(id: "Image", image: )
              }
              if (type == "audio") {
                //return BubbleNormalAudio(onSeekChanged: onSeekChanged, onPlayPauseButtonClick: onPlayPauseButtonClick)
              }
              List messages = snapshot.data.docs;
              return ChatView(
                chatController: ChatController(
                  initialMessageList: List.generate(messages.length, (index){
                    String message = messages[index]["message"];
                    DateTime createdAt = messages[index]["Time"].toDate();
                    String sentBy = messages[index]["sender"];
                    return Message(
                      message: message, 
                      createdAt: createdAt, 
                      sentBy: sentBy
                      );
                  }), 
                  scrollController: ScrollController(), 
                  otherUsers: List.generate(members.length, (index){
                    return ChatUser(
                      id: members[index], 
                      name: "User",
                      );
                  }), 
                  currentUser: ChatUser(id: user!.uid, name: "me")
                  ), 
                chatViewState: ChatViewState.hasMessages
                );
              
            },
          );
        },
      ),
     
    );
  }
}