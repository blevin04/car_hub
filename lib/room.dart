import 'package:car_hub/backendFxns.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final roomId;
  final roomName;
  const MyWidget({super.key,required this.roomId,required this.roomName});

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
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              String type = snapshot.data[index]["type"];
              String textM = snapshot.data[index]["message"];
              String sender = snapshot.data[index]["sender"];
              bool seen = snapshot.data[index]["seen"];
              if (type == "text") {
                return  Container();
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}