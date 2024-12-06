
import 'dart:io';

import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/room.dart';
import 'package:car_hub/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Chatrooms extends StatefulWidget {
  const Chatrooms({ Key? key }) : super(key: key);

  @override
  _ChatroomsState createState() => _ChatroomsState();
}
TextEditingController search_controller = TextEditingController();
class _ChatroomsState extends State<Chatrooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Rev Wave Chatrooms",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body:FutureBuilder(
        future: getrooms(),
        builder: (BuildContext context, AsyncSnapshot snapshot0) {
          if (snapshot0.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Card();
              },
            );
          }
          //print(snapshot0.data.length);
          return ListView.builder(
            itemCount: snapshot0.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
            color: Colors.transparent,
            elevation: 10,
            child: FutureBuilder(
              future: getroominFo(snapshot0.data[index]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin:const EdgeInsets.only(top: 20),
                            height: 20,
                            width: 120,
                            decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(20)),
                          ),
                          Container(
                            margin:const EdgeInsets.only(top: 5),
                            height: 10,
                            width: 150,
                            decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(20)),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey,
                            ),
                            height: 10,
                            width: 90,
                          )
                        ],
                      )
                    ],
                  );
                }
                Map roomInfo = snapshot.data;
                String roomName = roomInfo["Name"];
                String lastText = roomInfo["lastMessage"];
                DateTime lastTextTime = roomInfo["lastMessageTime"].toDate();
                String lastseen = duration(lastTextTime);
                List members = roomInfo["members"];
                return InkWell(
                  onTap: ()async{
                    if (!members.contains(user!.uid)) {
                       members.add(user!.uid);
                    }
                   
                    Map<String,dynamic> memberNames = await getMembersdata(members);
                    Navigator.push(context, (MaterialPageRoute(builder: (context)=>Room(roomId: snapshot0.data[index], roomName: roomName, memberNames: memberNames))));
                  },
                  child: ListTile(
                    title: Text(roomName,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                    subtitle: Text(lastText,style:const TextStyle(fontStyle: FontStyle.italic),),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding:const EdgeInsets.all(6),
                          decoration:const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue
                          ),
                          child:const Text("9",style: TextStyle(fontWeight: FontWeight.bold),)
                          ),
                        Text(lastseen)
                      ],
                    ),
                  ),
                );
              },
            ),
          );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding:const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20)
              ),
              child: TextButton(onPressed: ()async{
                Navigator.push(context, (MaterialPageRoute(builder: (context)=>const newRoom())));
              }, child: const Text("New",style: TextStyle(color: Colors.white),)),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 80,
              // padding:const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20)
              ),
              child:TextButton(onPressed: (){
                Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Join())));
              }, child: const Text("Join")),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
class Join extends StatelessWidget {
  const Join({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController search_controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SearchBar(
            controller:  search_controller,
            leading:const Icon(Icons.search),
          ),
          FutureBuilder(
            future: searchPublic(search_controller.text),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card();
                  },
                );
              }
              List publicRooms = snapshot.data;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot roomData = publicRooms[index];
                  Map roomMap = roomData.data()! as Map;
                  String name = roomMap["Name"];
                  String description = roomMap["description"];
                  int memberNum = roomMap["members"].length;
                  return Card(
                    child: ListTile(
                      minTileHeight: 80,
                      title: Text(name,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      subtitle: Text(description,style:const TextStyle(),overflow: TextOverflow.ellipsis,maxLines: 2,),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("${memberNum.toString()} members"),
                          InkWell(
                            onTap: () async{
                              await joinroom(roomData.id);
                            },
                            child:const Text("join +",style: TextStyle(color: Colors.blue),),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class newRoom extends StatelessWidget {
  const newRoom({super.key});

  @override
  Widget build(BuildContext context) {
    bool private = false;
    String coverImage = "";
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("Create new Room",style: TextStyle(fontWeight: FontWeight.bold),),),
          Padding(
            padding:const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(132, 59, 59, 59)
                  ),
                  borderRadius: BorderRadius.circular(15)
                ),
                hintText: "Room Name",
              ),
            ),
            ),
            Padding(
            padding:const EdgeInsets.all(10),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide:const BorderSide(
                    color: Color.fromARGB(132, 59, 59, 59)
                  ),
                  borderRadius: BorderRadius.circular(15)
                ),
                hintText: "Description",
              ),
            ),
            ),
            const Text("Visibility",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            StatefulBuilder(
              builder: (context,visibilityState) {
                return Row(
                  children: [
                    TextButton(onPressed: (){
                      visibilityState((){
                        private = false;
                      });
                    }, child: Row(
                      children: [const Text("Public"),Icon(private?Icons.check_box_outline_blank_outlined:Icons.check_box_outlined)],)),
                    TextButton(onPressed: (){
                      visibilityState((){
                        private = true;
                      });
                    }, child: Row(children: [const Text("Private"),Icon(private?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined)],)),
                    
                  ],
                );
              }
            ),
            StatefulBuilder(
              builder: (context,imageState) {
                return Container(
                  //padding:const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width-50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey
                    ),
                
                    image: coverImage.isEmpty?null:
                    DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(coverImage)))
                  ),
                  child: InkWell(
                    onTap: ()async{
                      coverImage = await getContent(context, FileType.image);
                      imageState((){});
                    },
                    child:const Column(
                      children: [
                        SizedBox(height: 20,),
                        Icon(Icons.image),
                        Text("Upload Cover image"),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                );
              }
            ),
            const SizedBox(height: 50,),
            Container(
              width: 200,
              padding:const EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.blue
              ),
              child: InkWell(
                onTap: ()async{
                  String state = "";
                  while (state.isEmpty) {
                    showDialog(context: context, builder: (context){return const Dialog(backgroundColor: Colors.transparent,child: Center(child: CircularProgressIndicator(color: Colors.blue,)),);});
                    state = await createRoom(nameController.text, !private, descController.text);
                  }
                 Navigator.pop(context);
                 if (state == "Success") {
                  Navigator.pop(context);
                   showsnackbar(context, "Created ${nameController.text} sucessfully");
                 }
                },
                borderRadius: BorderRadius.circular(20),
                child:const Text("Create room",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
              ),
            )
        ],
      ),
    );
  }
}