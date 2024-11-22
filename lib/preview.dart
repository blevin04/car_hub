import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Preview extends StatefulWidget {
  final String assetPath;
  final bool isImage;
  const Preview({super.key,required this.assetPath,required this.isImage});

  @override
  State<Preview> createState() => _PreviewState();
}

final player = AudioPlayer();
double rotationAngle = 0;
class _PreviewState extends State<Preview> {
  Duration length =Duration();

Future<String> initAudio()async{
  String state ="";
  await player.setSource(DeviceFileSource(widget.assetPath));
  await player.getDuration().then((onValue){
    length = onValue!;
  });
  player.setVolume(0.8);
return state;
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.isImage) {
      return Scaffold(
      body: Transform.rotate(
        angle:rotationAngle,
        child: Image(
          fit: BoxFit.cover,
          image:FileImage(File(widget.assetPath)) ),
      ),
        floatingActionButton: Container(
          margin:const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: (){}, icon:const Icon(Icons.check,color: Colors.white,)),
              InkWell(onTap: (){
                setState(() {
                  rotationAngle = 2;
                });
              }, child:const Icon(Icons.rotate_90_degrees_ccw,color: Colors.white,)),
              InkWell(onTap: (){
                setState(() {
                  rotationAngle = -2;
                });
              }, child:const Icon(Icons.rotate_90_degrees_cw_outlined,color: Colors.white,)),
              IconButton(onPressed: (){

              }, icon:const Icon(Icons.crop,color: Colors.white,)),
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon:const Icon(Icons.cancel_sharp,color: Colors.white,)),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
    }else{
      return Scaffold(
        body: FutureBuilder(
          future: initAudio(),
          builder: (context,futuresnap) {
            if (futuresnap.connectionState == ConnectionState.waiting) {
              return Center( child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.blue, size: 50),);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.blue, size: 50),
                ),
                StreamBuilder(
                  stream: player.onPositionChanged,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Slider(value: 0, onChanged: (value){});
                    }
                    //print(snapshot.data.inMilliseconds);
                    //print(length.inMilliseconds);
                    return Container(
                      child: Slider(
                        value:snapshot.data.inMilliseconds ==0?0: snapshot.data.inMilliseconds/length.inMilliseconds, 
                        onChanged: (value){
                          player.seek(Duration(milliseconds: value.round()));
                        }
                        ),
                        
                    );
                  },
                ),
                IconButton(onPressed: ()async{
                  player.state == PlayerState.playing?
                 await player.pause():
                 await player.resume();
                }, icon: Icon(
                  player.state == PlayerState.playing?
                  Icons.pause:
                  Icons.play_arrow

                  ))

              ],
            );
          }
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Row(
            children: [
              IconButton(onPressed: (){}, icon:const Icon(Icons.check)),
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon:const Icon(Icons.cancel))
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    }
    
  }
}