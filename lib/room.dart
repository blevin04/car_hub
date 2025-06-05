import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/utils.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Room extends StatefulWidget {
  final String roomId;
  final String roomName;
  final Map<String,dynamic> memberNames;
  const Room({super.key,required this.roomId,required this.roomName,required this.memberNames});
  static String uName = Hive.box("UserData").get("fullName");
  // static ScrollController _scrollController = new ScrollController();
  static TextEditingController textcontroller = TextEditingController();
  static AudioPlayer player0 = AudioPlayer();

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  final ScrollController _scrollController = ScrollController(onAttach:(pos){pos.animateTo(pos.maxScrollExtent,duration: const Duration(microseconds: 10),curve: Curves.bounceIn);});
  @override
  void initState() {
    super.initState();
     // Listen for user scroll
    _scrollController.addListener(() {
      // print("ooooooooooo");
      if (_scrollController.position.atEdge) {
        // Check if at the bottom
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
         
          // print("ppppppppppppppppp");
        } else {
          // print("llllllllllllll");
          
        }
      }
    });

    // Scroll to the bottom initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
     // _scrollToBottom();
    });
  }
  @override
  Widget build(BuildContext context) {
bool addVisible = false;
String mediaPath = "";
FileType previewType = FileType.any;
    return  Scaffold(
      appBar: AppBar(
        //leading:IconButton(onPressed: (){}, icon: icon)
        title: Row(
          children: [
            const Padding(
          padding:EdgeInsets.all(5.0),
          child: CircleAvatar(),
        ),
            Text(widget.roomName),
          ],
        ),
      ),
      endDrawer:Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              
            ),
            Text(widget.roomName),
            
          ],
        ),
      ),
      body: Expanded(
        child: StreamBuilder(
          stream: firestore.collection("rooms").doc(widget.roomId).collection("messages").orderBy("Time", descending: false).limit(50).snapshots(),
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
                // shrinkWrap: true,
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  bool mtime = isSameDay(noww, messages[index].data()["Time"].toDate());
                  noww = messages[index].data()["Time"].toDate();
                  bool istoday = isSameDay(DateTime.now(), noww);
                  String memberId = messages[index].data()["sender"];
                  String messageType = messages[index].data()["type"];
                  if (!widget.memberNames.containsKey(memberId)) {
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
                                child: Text(widget.memberNames[messages[index].data()["sender"]]),
                              ),
                            ],
                          )),
                          messageType == "text"?
                        BubbleNormal(
                          color: messages[index].data()["sender"]==user!.uid?Colors.blue:const Color.fromARGB(255, 59, 66, 59),
                          text: messages[index].data()["message"],
                          isSender: user!.uid == messages[index].data()["sender"],
                          textStyle:const TextStyle(color: Colors.white),
                          ):messageType == "image"?
                          BubbleNormalImage(
                            isSender: user!.uid == messages[index].data()["sender"],
                            id: "image", 
                            image: FutureBuilder(
                              future: getMessageMedia(messages[index].id, widget.roomId),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(height: 120,width: 100, child: Icon(Icons.image));
                                }
                                //print(snapshot.data.length);
                                return Image(image: MemoryImage(snapshot.data));
                              },
                            ),
                            ):messageType == "audio"?
                            BubbleNormalAudio(
                              isSender: user!.uid == messages[index].data()["sender"],
                              onSeekChanged: (pos){},
                               onPlayPauseButtonClick: (){}):
                               BubbleNormal(text: messages[index].data()["message"],)
                          ,
                    ],
                  );
                },
              ),
            );
          },
        ),
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
                  child: mediaPath.isEmpty?
                  Row(
                    children: [
                      IconButton(onPressed: ()async{
                      mediaPath = await getContent(context, FileType.image);
                      if (mediaPath.isNotEmpty) {
                        previewType = FileType.image;
                        barState((){});
                      }
                      }, icon:const Icon(Icons.image)),
                      IconButton(onPressed: ()async{
                        mediaPath = await getContent(context, FileType.any);
                        if (mediaPath.isNotEmpty) {
                          previewType = FileType.any;
                          barState((){});
                        }
                      }, icon: const Icon(Icons.document_scanner)),
                      IconButton(onPressed: ()async{
                        mediaPath = await getContent(context, FileType.audio);
                        if(mediaPath.isNotEmpty){
                          previewType = FileType.audio;
                          barState((){});
                        }
                      }, icon: const Icon(Icons.music_note)),
                      IconButton(onPressed: ()async{
                        mediaPath = await getContent(context, FileType.any);
                        if (mediaPath.isNotEmpty) {
                          previewType = FileType.any;
                          barState((){});
                        }
                      }, icon: const Icon(Icons.attach_file))
                    ],
                  ):
                  Container(
                    child: previewType == FileType.image?
                    Image(image: FileImage(File(mediaPath))):
                    previewType == FileType.audio?
                    Container():
                      Text(mediaPath.split("/").last)
                    ,
                  )
                  ,
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
                        controller:Room.textcontroller ,
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
                        String state ="";
                        if (mediaPath.isEmpty) {
                          state =await sendMessage(Room.textcontroller.text, widget.roomId, "text");
                        }else{
                          if (previewType == FileType.image) {
                            state =await sendMessage(Room.textcontroller.text, widget.roomId, "image",mediaPath);
                          }
                          if (previewType == FileType.audio) {
                            state =await sendMessage(Room.textcontroller.text, widget.roomId, "audio",mediaPath);
                          }
                          if (previewType == FileType.any) {
                            state =await sendMessage(Room.textcontroller.text, widget.roomId, "custom",mediaPath);
                          }
                        }
                       if (state == "Success") {
                        mediaPath = "";
                        previewType = FileType.any;
                        Room.textcontroller.clear();
                        barState((){});
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