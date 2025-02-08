import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Revmatch extends StatefulWidget {
  const Revmatch({super.key});

  @override
  State<Revmatch> createState() => _RevmatchState();
}
GifController gifController = GifController(
  autoPlay: false
);
GifController _gifController = GifController(
  autoPlay: true,
  inverted: false,
  loop: false,
);

ValueNotifier<bool> startUpDone = ValueNotifier(false);
PageController pageControllerG = PageController();
AudioPlayer audioPlayerG = AudioPlayer();
List playPositions = [];
class _RevmatchState extends State<Revmatch> {
  int currPage = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    pageControllerG = PageController();
    pageControllerG.addListener((){
      currPage = pageControllerG.page!.toInt()+1;
    }); 
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: preGame(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.black,
              Colors.white,
              Colors.black,
              // const Color.fromARGB(36, 33, 149, 243),
              Colors.white,
              Colors.black
            ],
            transform: GradientRotation(90)
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GifView.asset(
                controller: _gifController,
                "lib/assets/startup_gif.gif"
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Preparing Your experience ",style: TextStyle(color: Colors.blue),),
                    LoadingAnimationWidget.progressiveDots(color: Colors.white30, size: 20)
                  ],
                ),
                LoadingAnimationWidget.waveDots(color: Colors.indigoAccent, size: 50),
            ],
          ),
        ),
      );
    }
  playPositions = [0.0,0.0,0.0,0.0,0.0];
 ValueNotifier< List<bool>> playingAll =ValueNotifier([false,false,false,false,false]) ;
    Map<String,dynamic> tunesData = snapshot.data;
    Map<int,dynamic> selectedChoice = {};
    
    List tuneKeys = tunesData.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title:const Text("Rev Match",style: TextStyle(color: Colors.blue,fontSize: 20),),
        actions: [
          IconButton(onPressed: (){
            pageControllerG.animateToPage(pageControllerG.page!.ceil()-1, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
          }, icon:const Icon(Icons.keyboard_arrow_left)),
          ListenableBuilder(
            listenable: pageControllerG, 
            builder: (context,child){
              
              return Text("$currPage/5");
            }),
           IconButton(onPressed: (){
            pageControllerG.animateToPage(pageControllerG.page!.ceil()+1, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
          }, icon:const Icon(Icons.keyboard_arrow_right))
        ],
      ),
      body: PageView(
        controller: pageControllerG,
        children: List.generate(5, (index){
          // Future.delayed(const Duration(seconds: 1));
          return FutureBuilder(
            future: Future.delayed(const Duration(seconds: 1)),
            builder: (context,snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LoadingAnimationWidget.threeArchedCircle(color: Colors.white, size: 30);
              }
              ValueNotifier<Map> pageAnswer = ValueNotifier(selectedChoice.containsKey(pageControllerG.page!.toInt())?
          selectedChoice[pageControllerG.page!.toInt()]:{}); 
              return SingleChildScrollView(
                child: Column(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 3,
                      sigmaY: 2
                    ),
                    child: Card(
                      child: Container(
                         height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          invertColors: false,
                          fit: BoxFit.cover,
                          image: AssetImage("lib/assets/default_profile.webp"),),)
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(178, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListenableBuilder(
                          listenable: playingAll,
                          builder: (context,child) {
                            return IconButton(onPressed: (){
                            playingAll.value[index] = !playingAll.value[index];
                            playingAll.value[index] == false?
                            audioPlayerG.play(tunesData[tuneKeys[index]]["Mp3"]):
                            audioPlayerG.pause();
                            }, icon:Icon( 
                              playingAll.value[index]?
                              Icons.pause:
                              Icons.play_arrow));
                          }
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width-80,
                          child: Slider(
                          value: playPositions[index], 
                          onChanged: (valueNew){

                          },
                          thumbColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Engine",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),),
                      ),
                    ],
                  ),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2
                    ),
                    itemCount: 6,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                  "lib/assets/v8.jpeg"
                                )
                                
                                )
                              ),
                            ),
                            Text("V8",style: TextStyle(color: Colors.white,fontSize: 20),)
                          ],
                        ),
                      
                      );
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Vehicle",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2
                    ),
                    itemCount: 4,
                    shrinkWrap: true,
                    physics:const  NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                  "lib/assets/v8.jpeg"
                                )
                                
                                )
                              ),
                            ),
                            Text("V8",style: TextStyle(color: Colors.white,fontSize: 20),)
                          ],
                        ),
                      );
                    },
                  ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  )
                  
                ],
                ),
              );
            }
          );
        })
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
         Container(
          height: 50,
          width: MediaQuery.of(context).size.width/2 -30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20)
            ),
            color: Colors.blue
          ),
          child: Center(
            child: Text("Skip",style: TextStyle(
              color: Colors.white,
              fontSize: 23
            ),),
          ),
         ),
         Container(
          height: 50,
          width: MediaQuery.of(context).size.width/2 -30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)
            ),
            color: Colors.blueGrey
          ),
          child: Center(
            child: Text("Quit",style: TextStyle(
              color: Colors.white,
              fontSize: 23
            ),),
          ),
         )
        ],
      ),
    );
      },
    );
  }
}