import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:set_ringtone/set_ringtone.dart';
 //import 'package:ringtone_set_mul/ringtone_set_mul.dart';

class Tunes extends StatefulWidget {
  const Tunes({super.key});

  @override
  State<Tunes> createState() => _TunesState();
}
List trending_sounds =[
  "0",
  "2",
  "3",
  "4"
];
class _TunesState extends State<Tunes> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(toolbarHeight: 40,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(
              leading: Icon(Icons.search),
              hintText: "Search for model ,eg:Supra",
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Trending Sounds",
                style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Card(
              child: CarouselSlider(
                items: trending_sounds.map((index){
                  return InkWell(
                    child: Center(child: Text("sound number $index"),),
                  );
                }).toList(), 
                options: CarouselOptions(
                  autoPlay: true,
                  height: 200
                  )
                ),
            ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Pure Sounds",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                FutureBuilder(
                  future: getTunes(),
                  builder: (context,snapshot0) {
                    if (snapshot0.connectionState == ConnectionState.waiting) {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: 2,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return const Card();
                        },
                      );
                    }
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: snapshot0.data!.length,
                      //physics:const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        GifController gifController = GifController(autoPlay: false);
                        AudioPlayer player =AudioPlayer();
                        ValueNotifier playState = ValueNotifier(0);
                        
                        return Card(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GifView.asset("lib/assets/44zG.gif",controller: gifController,),
                              IconButton(onPressed: ()async{
                   
                                //Uint8List audio = Uint8List(100);
                                playState.value = 1;
                                
                                Uint8List  audio = await gettuneData(snapshot0.data![index].id);
                                
                                player.onPlayerStateChanged.listen((event){
                                  if (event == PlayerState.completed) {
                                    playState.value = 0;
                                  }
                                    if (player.source != BytesSource(audio)) {
                                      //playState.value = 0;
                                    }
                                  });
                                 
                                   if (player.state == PlayerState.playing) {
                                     player.pause();
                                     playState.value = 0;
                                     gifController.pause();
                                   }else{
                                     player.play(BytesSource(audio));
                                     gifController.play();
                                    playState.value = 2;
                                   }
                                  //  print("llllllllllllllllllllllllllll");
                                 
                              }, icon: ListenableBuilder(
                                listenable: Listenable.merge([playState]),
                              builder: (context,child){
                                if (playState.value == 0) {
                                  return const Icon(Icons.play_circle,size: 40,);
                                }if (playState.value == 2) {
                                  return const Icon(Icons.pause,size: 40,);
                                }
                                return const Center(child: CircularProgressIndicator(),);
                              }))
                            ],
                          ),
                        );
                        // return FutureBuilder(
                        //   future: gettuneData(snapshot0.data![index].id),
                        //   builder: (BuildContext context, AsyncSnapshot snapshot1) {
                        //     if (snapshot1.connectionState == ConnectionState.waiting) {
                        //       return Card(
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           children: [
                        //             GifView.asset("lib/assets/44zG.gif"),
                        //             const CircularProgressIndicator(),
                        //           ],
                        //         ),
                        //       );
                        //     }
                        //     return Card(
                        //   child: InkWell(
                        //     onTap: (){
                        //       showDialog(context: context, builder: (context){
                        //         return Dialog(
                        //           child: SizedBox(
                        //             height: 200,
                        //             child: Column(
                        //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //               children: [
                        //                 const Text("Set as:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                        //                 TextButton(onPressed: ()async{
                        //                   File file = File.fromRawPath(snapshot1.data);
                        //                   await Ringtone.setRingtoneFromFile(file);
                        //                 }, child:const Text("Ringtone")),
                        //                 TextButton(onPressed: ()async{
                        //                    File file = File.fromRawPath(snapshot1.data);
                        //                    Ringtone.setNotificationFromFile(file);
                        //                 }, child:const Text("Notification sound")),
                        //                 TextButton(onPressed: ()async{
                        //                   File file = File.fromRawPath(snapshot1.data);
                        //                   await Ringtone.setAlarmFromFile(file);
                        //                 }, child: const Text("Alarm Sound"))
                        //               ],
                        //             ),
                        //           ),
                        //         );
                        //       });
                        //     },
                        //     child: Column(
                        //       children: [
                        //         StatefulBuilder(
                        //           builder: (context,state) {
                        //             return Stack(
                        //               alignment: Alignment.center,
                        //               children: [
                        //                 GifView.asset(
                        //                   controller: gifController,
                        //                   "lib/assets/44zG.gif"
                        //                   ),
                        //                   IconButton(
                        //                 onPressed: (){
                        //                   // player.setSource()
                        //                   // print(player.state);
                        //                   player.state == PlayerState.playing?
                        //                   player.stop():
                        //                   player.play(BytesSource(snapshot1.data));
                        //                 gifController.isPlaying?
                        //                 gifController.stop():gifController.play();
                        //                 state((){});
                        //               }, icon:gifController.isPlaying?
                        //               const Icon(Icons.pause):
                        //               const Icon(Icons.play_circle_fill,size: 40,))
                        //               ],
                        //             );
                        //           }
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // );
                        //   },
                        // );
                      },
                    );
                  }
                ),
                ],
              ),
            ),
            
            
        
          ],
        ),
      ),
    );
  }
}