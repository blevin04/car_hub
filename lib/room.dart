import 'package:car_hub/backendFxns.dart';
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
          padding:EdgeInsets.all(5.0),
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
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return ;
            },
          );
        },
      ),
      floatingActionButton: Container(
        padding:const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            IconButton(onPressed: (){}, icon:const Icon(Icons.attach_file)),
            IconButton(onPressed: (){}, icon:const Icon(Icons.camera_alt)),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Text",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
              ),
            ),
            IconButton(
              onPressed: (){

            }, icon:const Icon(Icons.send))
          ],
        ),
      ),
    );
  }
}