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
        stream: firestore.collection("rooms").doc(roomId).collection("messages").limit(30).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          
          if (snapshot.data.docs.isEmpty) {
            
            return ChatView(
              messageConfig: MessageConfiguration(
              ),
              typeIndicatorConfig: TypeIndicatorConfiguration(
              ),
              chatController: ChatController(
                initialMessageList: List.empty(), 
                scrollController: ScrollController(), 
                otherUsers: List.empty(), 
                currentUser: ChatUser(id: user!.uid, name: uName)), 
              chatViewState: ChatViewState.noData,
              onSendTap: (message, replyMessage, messageType)async {
                //print(message);
                String type = "";
                if ( messageType.isText) {
                  type = "text";

                }
                if (messageType.isImage) {
                  type = "image";

                }
                if (messageType.isVoice) {
                  type = "audio";
                }
                if (messageType.isCustom) {
                  type = "custom";
                }
                await sendMessage(message, roomId, type);
              },
              );
          }
          List members = info["members"];
          print(snapshot.data.docs);
          return 
               ChatView(
                chatBubbleConfig: ChatBubbleConfiguration(

                ),
                loadingWidget:const CircularProgressIndicator(),
                onSendTap: (message, replyMessage, messageType) {
                  String type = "";
                if ( messageType.isText) {
                  type = "text";

                }
                if (messageType.isImage) {
                  type = "image";

                }
                if (messageType.isVoice) {
                  type = "audio";
                }
                if (messageType.isCustom) {
                  type = "custom";
                }
                  sendMessage(message, roomId, type);
                  
                  
                },
                sendMessageConfig: SendMessageConfiguration(
                  textFieldConfig: TextFieldConfiguration(
                    textStyle: TextStyle(color: Colors.black)
                  )
                ),
                chatBackgroundConfig: ChatBackgroundConfiguration(
                  backgroundColor: Colors.grey,
                  messageTimeTextStyle: TextStyle(color: Colors.black,backgroundColor: Colors.blue)
                ),
                chatViewState:snapshot.data.docs.isEmpty?ChatViewState.noData: ChatViewState.hasMessages,
                chatController: ChatController(
                  
                  initialMessageList: List.generate(snapshot.data.docs.length, (index){
                    String type = snapshot.data.docs[index]["type"];
                    String textM = snapshot.data.docs[index]["message"];
                    String sender = snapshot.data.docs[index]["sender"];
                    //var seen = snapshot.data.docs[index]["Seen"];
                    DateTime time = snapshot.data.docs[index]["Time"].toDate();
                    MessageType type0 = MessageType.text;
                    if (type == "text") {
                      type0 = MessageType.text;
                    }
                    if (type == "audio") {
                      type0 = MessageType.voice;
                    }
                    if (type == "image") {
                      type0 = MessageType.image;
                    }
                    return Message(
                      messageType: type0,
                      message: textM, 
                      createdAt: time, 
                      sentBy: sender,
                      status: MessageStatus.delivered
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