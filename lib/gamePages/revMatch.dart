import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:gif_view/gif_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waveform_flutter/waveform_flutter.dart';
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
List engines = [
  "V8",
  "V10",
  "V12",
  "V6",
  "V16",
  "I3",
  "I4",
  "I5",
  "I6",
  "W12",
  "W16",
  "Rotery",
  "F4",
  "F6"
];
double scorerv = 00;
ValueNotifier<bool> startUpDone = ValueNotifier(false);
ValueNotifier<Map> selectedEngines = ValueNotifier({});
ValueNotifier<String> completed = ValueNotifier("undone");
PageController pageControllerG = PageController();
AudioPlayer audioPlayerG = AudioPlayer();
List playPositions = [];
late DateTime startTime;
void showScore(double score,BuildContext context)
async{
  showDialog(context: context, builder: (context){
    return Dialog(
      child: SizedBox(
        height: 350,
        width: 300,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Your Score",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50
            ),),
            Text(score.roundToDouble().toString(),
          style:const TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 100),),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child:const Text("View results"))
          ],
        )
      ),
    );
  });
  Center(
        child: Confetti(controller: Confetti.launch(context, options: 
        ConfettiOptions(
         startVelocity: 45,
         scalar: 1.2,
         ticks: 200,
         
        ))),
        );
}
class _RevmatchState extends State<Revmatch> {
  int currPage = 1;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayerG.stop();
    // selectedEngines.dispose();
    // pageControllerG.dispose();
    // completed.dispose();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime = DateTime.now();
    
    pageControllerG = PageController();
    pageControllerG.addListener((){
      currPage = pageControllerG.page!.toInt()+1;
    }); 
  }
  void restart(){
    selectedEngines.value.clear();
    completed.value = "undone";
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    Map choices  = {};
         startTime = DateTime.now();
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
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            alignment: Alignment.bottomCenter,
            children: [
                Center(
                  child: GifView.asset(
                    controller: _gifController,
                    "lib/assets/startup_gif.gif"
                    ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                
            ],
          ),
        ),
      );
    }

  playPositions = [0.0,0.0,0.0,0.0,0.0];
 ValueNotifier< List<bool>> playingAll =ValueNotifier([false,false,false,false,false]) ;
    Map<String,dynamic> tunesData = snapshot.data;
    List tuneKeys = tunesData.keys.toList();
    for (var i = 0; i < 5; i++) {
           List choice = List.empty(growable: true);
           choice.add(tunesData[tuneKeys[i]]["categories"].first);
           while(choice.length<6){
            int rand = Random().nextInt(engines.length);
            if (!choice.contains(engines[rand])) {
              choice.add(engines[rand]);
            }
           }
           choices.addAll({i:choice});
         }
         print(choices);
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
          ValueNotifier playChange = ValueNotifier(true);
         ValueNotifier<bool> newSelection = ValueNotifier(false);
          return FutureBuilder(
            future: audioPlayerG.setSource(BytesSource(tunesData[tuneKeys[index]]["MP3"])),
            builder: (context,snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LoadingAnimationWidget.threeArchedCircle(color: Colors.white, size: 30);
              }
               
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
                  StatefulBuilder(
                    builder: (context,state0) {
                      Stream<Amplitude> active = createRandomAmplitudeStream();
                      Stream<Amplitude> inactive = Stream.periodic(
                                const Duration(milliseconds: 70),
                                (count) => Amplitude(
                                  current: 100,
                                  max: 100,
                                ),
                              );
                      return Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromARGB(178, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListenableBuilder(
                              listenable: playChange,
                              builder: (context,child) {
                                // print("lllllllllllllllllll");
                                return IconButton(
                                  onPressed: (){
                                    // print(tunesData[tuneKeys[index]].keys.toList());
                                    
                                if (playingAll.value[index] == false) {
                                  audioPlayerG.play(BytesSource(tunesData[tuneKeys[index]]["MP3"]));
                                  playingAll.value[index] = true;
                                  playChange.value = !playChange.value;
                                }else{
                                  audioPlayerG.pause();
                                  playingAll.value[index] = false;
                                  playChange.value = !playChange.value;
                                }
                                state0((){});
                                }, icon:Icon( 
                                  playingAll.value[index] == true?
                                  Icons.pause:
                                  Icons.play_arrow));
                              }
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  SizedBox(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width/1.5,
                                    child:
                                    playingAll.value[index]==true?
                                    AnimatedWaveList(
                                      key:const Key("animatedWaveList0"),
                                      stream: active):
                                      AnimatedWaveList(stream: inactive,key:const Key("AnimatedWaveList1"),)
                                    // AnimatedWaveList(
                                    //       stream:active,
                                    //       ):
                                    //       AnimatedWaveList(stream: inactive)
                                       
                                  )
                                
                            )
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width-80,
                            //   child: FutureBuilder(
                            //     future: audioPlayerG.getDuration(),
                            //     initialData:const Duration(microseconds: 1),
                            //     builder: (context,snapshot) {
                            //       if (snapshot.connectionState == ConnectionState.waiting) {
                            //         return LinearProgressIndicator();
                            //       }
                            //       // DateTime startT = DateTime.now();
                            //       return StreamBuilder(
                            //         stream: audioPlayerG.onPositionChanged,
                            //         initialData:const Duration(microseconds: 0),
                            //         builder: (context, snapshot1) {
                            //           return Slider(
                            //             value: snapshot1.data!.inMicroseconds/snapshot.data!.inMicroseconds, 
                            //             activeColor: Colors.blue,
                            //             onChanged: (value){
                                      
                            //           });
                            //         }
                            //       );
                            //     }
                            //   )
                            // ),
                          ],
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 10,),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                       const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:EdgeInsets.all(5.0),
                        child: Text("Engine",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),),
                      ),
                    ],
                  ),
                  ListenableBuilder(
                    listenable: Listenable.merge([newSelection,completed]),
                    builder: (context,child) {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2
                        ),
                        itemCount: 6,
                        shrinkWrap: true,
                        physics:const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int EngineIndex) {
                          List engineOptions = List.empty(growable: true);
                          
                           engineOptions = choices[index];
                          return Card(
                            child: InkWell(
                              onTap: (){
                                print("selected ${selectedEngines.value}");
                                if (completed.value != "marked") {
                                   selectedEngines.value.update(index,(value)=>engineOptions[EngineIndex],ifAbsent: () => engineOptions[EngineIndex],);
                                if (selectedEngines.value.length == 5) {
                                  completed.value = "filled";
                                }
                                newSelection.value = !newSelection.value;
                                }
                               
                              },
                              child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border:
                                          completed.value == "marked"?
                                          engineOptions[EngineIndex] == tunesData[tuneKeys[index]]["categories"].first?
                                          Border.all(
                                            width: 5,
                                            color: Colors.green
                                          ):
                                          engineOptions[EngineIndex] == selectedEngines.value[index]?
                                          Border.all(
                                            width: 5,
                                            color: Colors.red
                                          ):
                                          Border.all(width: 5,color: Colors.transparent)
                                          : Border.all(
                                            width:5,
                                            color: selectedEngines.value.containsKey(index)?
                                            selectedEngines.value[index]==engineOptions[EngineIndex]?
                                            Colors.blue:Colors.transparent:Colors.transparent
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              engineOptions[EngineIndex]=="V8"?
                                              "lib/assets/v8.jpg":
                                            "lib/assets/${engineOptions[EngineIndex]}.png"
                                          )
                                          
                                          )
                                        ),
                                      ),
                                    
                                  Text(engineOptions[EngineIndex].toString(),style: TextStyle(color: Colors.white,fontSize: 20),)
                                ],
                              ),
                            ),
                          
                          );
                        },
                      );
                    }
                  ),
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text("Vehicle",style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold
                  //     ),)
                  //   ],
                  // ),
                  // GridView.builder(
                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     childAspectRatio: 2
                  //   ),
                  //   itemCount: 4,
                  //   shrinkWrap: true,
                  //   physics:const  NeverScrollableScrollPhysics(),
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return Card(
                  //       child: Stack(
                  //         alignment: Alignment.bottomLeft,
                  //         children: [
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(10),
                  //               image: DecorationImage(
                  //                 fit: BoxFit.cover,
                  //                 image: AssetImage(
                  //                 "lib/assets/v8.jpg"
                  //               )
                                
                  //               )
                  //             ),
                  //           ),
                  //           Text("V8",style: TextStyle(color: Colors.white,fontSize: 20),)
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width/2 -30,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(20),
              color: Colors.blue
            ),
            child: InkWell(
              onTap: ()async{
                scorerv = 0.0;
                if (completed.value == "filled") {
                  Duration taken = DateTime.now().difference(startTime);
                  selectedEngines.value.forEach((key,value){
                    if (value == tunesData[tuneKeys[key]]["categories"].first) {
                      scorerv+=80/5;
                    }
                  });
                  print(taken.inSeconds);
                  print(taken.inMinutes);
                  if (taken.inMinutes <1) {
                    var bonus =(taken.inSeconds)/60;
                    bonus= bonus*20;
                    scorerv+=bonus;
                    print(taken.inSeconds);
                    print(scorerv);
                  }else if (taken.inMinutes<5) {
                    var bonus = taken.inSeconds/(60*5);
                    bonus = bonus *15;
                    scorerv+=bonus;
                    
                  }
                  
                  // print(scorerv);
                  UpdateHighScore(scorerv, 0);
                  showScore(scorerv, context);
                  completed.value = "marked";
                }else 
                if (completed.value == "marked") {
                  restart();
                }else{
                  pageControllerG.animateToPage(pageControllerG.page!.toInt()+1, duration:const Duration(milliseconds: 200), curve: Curves.bounceInOut);
                }
                
              },
              child: Center(
                child: ListenableBuilder(
                  listenable: completed,
                  builder: (context,child) {
                    return Text(
                      completed.value == "filled"?
                      "Finish":
                      completed.value == "marked"?
                      "Play again":
                      "Next",style: TextStyle(
                      color: Colors.white,
                      fontSize: 23
                    ),);
                  }
                ),
              ),
            ),
           ),
      ),
    );
      },
    );
  }
}