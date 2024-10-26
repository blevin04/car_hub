import 'package:car_hub/homepage.dart';
import 'package:car_hub/profile_Page.dart';
import 'package:car_hub/tunes.dart';
import 'package:car_hub/wallpapers.dart';
import 'package:flutter/material.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}
List scale = [1.0,1.0,1.0,1.0];
int currentPage = 0;
class _MobileLayoutState extends State<MobileLayout> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              scale[0] = 1.3;
              currentPage = 0;
              setState(() {
                
              });
            },
            child: AnimatedScale(
              scale: scale[0],
              duration:const Duration(milliseconds: 200),
              child: Column(
                children: [
                  Icon(Icons.home,color: currentPage==0?const Color.fromARGB(255, 248, 74, 0):null,),
                  Text("Home",style: TextStyle(fontSize: 14,color: currentPage==0?const Color.fromARGB(255, 248, 74, 0):null),),
                ]
                ),
              onEnd: (){
                scale[0] = 1.0;
                setState(() {
                  
                });
              },
              ),
          ),
        //  IconButton(onPressed: (){}, ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              scale[1] = 1.3;
              currentPage = 1;
              setState(() {
                
              });
            },
            child: AnimatedScale(
              scale: scale[1],
              duration:const Duration(milliseconds: 200),
              child: Column(
                children: [
                  Icon(Icons.image,color: currentPage==1?const Color.fromARGB(255, 248, 74, 0):null,),
                  Text("Wallpaper",style: TextStyle(fontSize: 14,color: currentPage==1?const Color.fromARGB(255, 248, 74, 0):null),),
                ]
                ),
              onEnd: (){
                scale[1] = 1.0;
                setState(() {
                  
                });
              },
              ),
          ),
          InkWell(
            radius: 20,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              currentPage = 2;
              scale[2] = 1.3;
              setState(() {
                
              });
            },
            child: AnimatedScale(
              scale: scale[2],
              duration:const Duration(milliseconds: 200),
              child: Column(
                children: [
                  Icon(Icons.music_note_outlined,color: currentPage==2?const Color.fromARGB(255, 248, 74, 0):null,),
                  Text("Revs",style: TextStyle(fontSize: 14,color: currentPage==2?const Color.fromARGB(255, 248, 74, 0):null),),
                ]
                ),
              onEnd: (){
                scale[2] = 1.0;
                setState(() {
                  
                });
              },
              ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              currentPage = 3;
              scale[3] = 1.3;
              setState(() {
                
              });
            },
            child: AnimatedScale(
              scale: scale[3],
              duration:const Duration(milliseconds: 200),
              child: Column(
                children: [
                  Icon(Icons.person_2,color: currentPage==3?const Color.fromARGB(255, 248, 74, 0):null,),
                  Text("Profile",style: TextStyle(fontSize: 14,color: currentPage==3?const Color.fromARGB(255, 248, 74, 0):null),),
                ]
                ),
              onEnd: (){
                scale[3] = 1.0;
                setState(() {
                  
                });
              },
              ),
          ),
        ],
      ),
      ),
      body: currentPage == 0?
     const Homepage():currentPage == 1?
     const Wallpapers():currentPage == 2?
     const Tunes():const ProfilePage()
    );
  }
}