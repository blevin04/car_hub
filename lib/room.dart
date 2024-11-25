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
      endDrawer:Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              
            ),
            Text(roomName),
            ListTile()
          ],
        ),
      ),
      body: StreamBuilder(
        stream: firestore.collection("rooms").doc(roomId).collection("messages").orderBy("Time", descending: false).limit(30).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child:CircularProgressIndicator());
          }
          List messages = snapshot.data.docs;
          return ChatView(
            chatBubbleConfig: ChatBubbleConfiguration(
              inComingChatBubbleConfig: ChatBubble(

              ),
              outgoingChatBubbleConfig: ChatBubble(

              )
            ),
            messageConfig: MessageConfiguration(

            ),
                onSendTap:(message, replyMessage, messageType) async {
                  await sendMessage(message, roomId, "text");
                },
                chatController: ChatController(
                  initialMessageList: List.generate(messages.length, (index){
                    String message = messages[index]["message"];
                    DateTime createdAt = messages[index]["Time"].toDate();
                    String sentBy = messages[index]["sender"];
                    return Message(
                      reaction: Reaction(
                        reactions: List.empty(), 
                        reactedUserIds: List.empty()
                        ),
                      message: message, 
                      createdAt: createdAt, 
                      sentBy: sentBy,
                      status: MessageStatus.delivered
                      );
                  }), 
                  
                  scrollController: ScrollController(), 
                  otherUsers: List.generate(info.length, (index){
                    String id = info.keys.toList()[index];
                    String name = info[id];
                    return ChatUser(
                      id: id, 
                      name: name,
                      );
                  }), 
                  currentUser: ChatUser(id: user!.uid, name: "me")
                  ), 
                chatViewState: ChatViewState.hasMessages,
                sendMessageConfig: SendMessageConfiguration(
                    micIconColor: Colors.black,
                    imagePickerIconsConfig: ImagePickerIconsConfiguration(
                      cameraIconColor: Colors.black,
                      galleryIconColor: Colors.black
                    ),
                  textFieldConfig: TextFieldConfiguration(
                    textStyle: TextStyle(color: Colors.black)
                  )
                ),
                );
        },
      ),
     
    );
  }
}