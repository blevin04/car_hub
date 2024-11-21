import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/utils.dart';
import 'package:flutter/material.dart';

class Chatrooms extends StatefulWidget {
  const Chatrooms({ Key? key }) : super(key: key);

  @override
  _ChatroomsState createState() => _ChatroomsState();
}

class _ChatroomsState extends State<Chatrooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getrooms(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.data.isEmpty) {
            return Center(child: TextButton(onPressed: (){}, 
            child:const Text("Join Any public chatroom")),);
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              List roomIds = snapshot.data;
              return FutureBuilder(
                future: getroominFo(roomIds[index]),
                builder: (BuildContext context, AsyncSnapshot snapshot1) {
                  String roomName = snapshot1.data["Name"];
                  String lastMessage = snapshot1.data["lastMessage"];
                  DateTime time = snapshot1.data["lastMessageTime"].toDate();
                  String duration0 = duration(time);
                  return ListTile(
                    onTap: (){
                      
                    },
                    leading: CircleAvatar(),
                    title: Text(roomName),
                    subtitle: Text(lastMessage),
                    trailing: Text(duration0),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}