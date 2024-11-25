import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wallpaper_handler/wallpaper_handler.dart';

class PreviewWallpaper extends StatefulWidget {
  final bytes;
  const PreviewWallpaper({super.key,required this.bytes});
  
  @override
  State<PreviewWallpaper> createState() => _Preview0State();
}
 int rotationAngle = 0;
 bool showSlider = false;
 

class _Preview0State extends State<PreviewWallpaper> {
  double initial = 0.5;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Transform.rotate(
        angle:rotationAngle*(pi/180),
        child: Image(
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
          image:MemoryImage(widget.bytes) ),
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
                visible:showSlider ,
                child: Slider(
                  activeColor: const Color.fromARGB(158, 3, 168, 244),
                  inactiveColor:const Color.fromARGB(117, 3, 168, 244),
                  thumbColor: Colors.blue,
                  value:initial, 
                  min: -1,
                  max: 1,
                  onChanged: (value){
                    setState(() {
                      initial = value;
                       rotationAngle+=(value*10) as int;
                    });
                   
                  })
                ),
            Container(
              //constraints:const BoxConstraints(maxHeight: 100,minHeight: 60),
              margin:const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(onPressed: ()async{
                        showDialog(context: context, builder: (context){
                          return Dialog(
                            child: SizedBox(
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  TextButton(onPressed: ()async{
                                    
                                    String filepath = File.fromRawPath(widget.bytes).path;
                                    await WallpaperHandler.instance.setWallpaperFromFile( filepath, WallpaperLocation.homeScreen);
                                     Navigator.popUntil(context, ModalRoute.withName("/tunes"));
                                  }, child:const Text("Home Screen")),
                                  TextButton(onPressed: ()async{
                                     String filepath = File.fromRawPath(widget.bytes).path;
                                    await WallpaperHandler.instance.setWallpaperFromFile( filepath, WallpaperLocation.lockScreen);
                                     Navigator.popUntil(context, ModalRoute.withName("/tunes"));
                                  }, child:const  Text("Lock Screen")),
                                  TextButton(onPressed: ()async{
                                     String filepath = File.fromRawPath(widget.bytes).path;
                                    await WallpaperHandler.instance.setWallpaperFromFile( filepath, WallpaperLocation.bothScreens);
                                    Navigator.popUntil(context, ModalRoute.withName("/tunes"));
                                  }, child:const  Text("Both Screens"))
                                ],
                              ),
                            ),
                          );
                        });
                        
                      }, icon:const Icon(Icons.check,color: Colors.white,)),
                      InkWell(
                        onTap: (){
                          initial = 0;
                          if ((rotationAngle%90) !=0) {
                            if (rotationAngle<90) {
                            rotationAngle = 90;
                          }
                          if (rotationAngle >90 && rotationAngle<=180) {
                            rotationAngle = 180;
                          }
                          if (rotationAngle>180 &&rotationAngle<270) {
                            rotationAngle = 270;
                          }
                          if(rotationAngle>270){
                            rotationAngle = 0;
                          }
                          }else{
                            rotationAngle-=90;
                          }
                          
                        setState(() {
                          showSlider = true;

                        });
                      }, child:const Icon(Icons.rotate_90_degrees_ccw,color: Colors.white,)),
                      InkWell(onTap: (){
                        if ((rotationAngle % 90)!=0) {
                          initial = 0;
                          if (rotationAngle<90) {
                            rotationAngle = 90;
                          }
                          if (rotationAngle >90 &&rotationAngle<=180) {
                            rotationAngle = 180;
                          }
                          if (rotationAngle>180 &&rotationAngle<=270) {
                            rotationAngle = 270;
                          }
                          if (rotationAngle >270) {
                            rotationAngle = 0;
                          }
                        }else{
                          rotationAngle+=90;
                        }
                        setState(() {
                          showSlider = true;
                        });
                      }, child:const Icon(Icons.rotate_90_degrees_cw_outlined,color: Colors.white,)),
                     
                      InkWell(onTap: (){
                        Navigator.pop(context);
                      }, child:const Icon(Icons.cancel_sharp,color: Colors.white,)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}