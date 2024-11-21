import 'package:car_hub/authPage.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/room.dart';
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
      appBar: AppBar(
        title:const Text("Rev Wave Chatrooms",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: FutureBuilder(
        future: getrooms(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.data.isEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchBar(
                    hintText: "Search for a public room to join",
                  ),
                ),
                ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(),
                      title: Text("Room title"),
                      trailing: Text("20 members"),
                    );
                  },
                ),
              ],
            );
          }
          print(snapshot.data);
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              List roomIds = snapshot.data;
              return FutureBuilder(
                future: getroominFo(roomIds[index]),
                builder: (BuildContext context, AsyncSnapshot snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot1.hasData) {
                    return const Center(child: Text("No data refresh page"),);
                  }
                  String roomName = snapshot1.data["Name"];
                  String lastMessage = snapshot1.data["lastMessage"];
                  DateTime time = snapshot1.data["lastMessageTime"].toDate();
                  String duration0 = duration(time);
                  return ListTile(
                    shape:const Border(top: BorderSide(color: Colors.grey)),
                    onTap: (){
                      Navigator.push(context, (MaterialPageRoute(builder: (context)=>Room(roomId: roomIds[index], roomName: roomName, info: snapshot1.data))));
                    },
                    leading: CircleAvatar(),
                    title: Text(roomName,style:const TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(lastMessage),
                    trailing: Text(duration0),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        padding:const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20)
        ),
        child: TextButton(onPressed: ()async{
          Navigator.push(context, (MaterialPageRoute(builder: (context)=>const newRoom())));
        }, child: const Text("New",style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}

class newRoom extends StatelessWidget {
  const newRoom({super.key});

  @override
  Widget build(BuildContext context) {
    bool private = false;
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Create new Room",style: TextStyle(fontWeight: FontWeight.bold),),),
          Padding(
            padding: EdgeInsets.all(10),
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
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(132, 59, 59, 59)
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