import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/utils.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Room extends StatelessWidget {
  final String roomId;
  final String roomName;
  final Map<String,dynamic> memberNames;
  const Room({super.key,required this.roomId,required this.roomName,required this.memberNames});
  static String uName = Hive.box("UserData").get("fullName");
  // static ScrollController _scrollController = new ScrollController();
  static TextEditingController textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
bool addVisible = false;
    return  Scaffold(
      appBar: AppBar(
        //leading:IconButton(onPressed: (){}, icon: icon)
        title: Row(
          children: [
            const Padding(
          padding:EdgeInsets.all(5.0),
          child: CircleAvatar(),
        ),
            Text(roomName),
          ],
        ),
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
        stream: firestore.collection("rooms").doc(roomId).collection("messages").orderBy("Time", descending: false).limit(50).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child:CircularProgressIndicator());
          }
          List messages = snapshot.data.docs;
          DateTime noww = messages.first.data()["Time"].toDate();
          // bool isToday = noww.isAfter(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
          return Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              controller: ScrollController(
                onAttach: (position){
                 print(Hive.box(roomId).keys);
                 if (Hive.box(roomId).containsKey("position")) {
                   position.animateTo(Hive.box(roomId).get("position"), duration:const Duration(microseconds: 10), curve: Curves.bounceInOut);
                 }else{
                  // double pos = position.maxScrollExtent;
                  position.animateTo(messages.length*40,duration:const Duration(microseconds: 10), curve: Curves.bounceInOut );
                  
                 }
                  //position.animateTo(to, duration: duration, curve: curve)
                },
                onDetach: (position) {
                  Hive.box(roomId).put("position", position.maxScrollExtent);
                },
              ),
              itemBuilder: (BuildContext context, int index) {
                bool mtime = isSameDay(noww, messages[index].data()["Time"].toDate());
                noww = messages[index].data()["Time"].toDate();
                bool istoday = isSameDay(DateTime.now(), noww);
                String memberId = messages[index].data()["sender"];
                if (!memberNames.containsKey(memberId)) {
                  // print(memberId);
                }
                // print(memberNames.containsKey(memberId));
                return Column(
                  children: [
                    Visibility(
                      visible: !mtime,
                      child: Text(
                        istoday?
                        "Today":
                        isSameDay(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day-1), noww)?
                        "Yesterday":
                        "${noww.year}-${noww.month}-${noww.day}"
                        ),
                      ),
                      Visibility(
                        visible:user!.uid != messages[index].data()["sender"],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(memberNames[messages[index].data()["sender"]]),
                            ),
                          ],
                        )),
                      BubbleNormal(
                        color: messages[index].data()["sender"]==user!.uid?Colors.blue:const Color.fromARGB(255, 59, 66, 59),
                        text: messages[index].data()["message"],
                        isSender: user!.uid == messages[index].data()["sender"],
                        textStyle:const TextStyle(color: Colors.white),
                        ),
                  ],
                );
              },
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: Container(
        padding:const EdgeInsets.only(left: 10),
        child: StatefulBuilder(
          builder: (context,barState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible:  addVisible,
                  child: Row(
                    children: [
                      IconButton(onPressed: (){}, icon:const Icon(Icons.image)),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.document_scanner)),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.music_note)),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.attach_file))
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: (){
                      barState((){
                        addVisible = !addVisible;
                      });
                    }, icon:const Icon(Icons.attach_file)),
                    IconButton(onPressed: (){
                
                    }, icon:const Icon(Icons.camera_alt)),
                    Expanded(
                      child: TextField(
                        controller:textcontroller ,
                        decoration: InputDecoration(
                          hintText: "Text",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          )
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: ()async{
                       String state =await sendMessage(textcontroller.text, roomId, "text");
                       if (state == "Success") {
                        textcontroller.clear();
                       }
                    }, icon:const Icon(Icons.send))
                  ],
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}