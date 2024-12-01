import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/categories.dart';
import 'package:car_hub/homepage.dart';
import 'package:car_hub/profile_Page.dart';
import 'package:car_hub/tunes.dart';
import 'package:car_hub/utils.dart';
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

class _PreviewState extends State<Preview> {
  bool showSlider = false;
  Duration length =Duration();
  double initial = 0.5;
double rotationAngle = 0;
Future<String> initAudio()async{
  String state ="";
  await player.setSource(DeviceFileSource(widget.assetPath));
  await player.getDuration().then((onValue){
    length = onValue!;
  });
  //player.setVolume(0.8);
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
        angle:rotationAngle*(pi/180),
        child: Image(
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
          image:FileImage(File(widget.assetPath)) ),
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
                  value: initial, 
                  min: -1,
                  max: 1,
                  onChanged: (value){
                    setState(() {
                      initial = value;
                       rotationAngle+=(value*10);
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
                                  TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:const BorderSide(
                                          color: Colors.grey
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: "Add name/ description",
                                    ),
                                  ),
                                  TextButton(onPressed: ()async{
                                    Navigator.pop(context);
                                    String state = "";
                                    while (state.isEmpty){
                                      showDialog(context: context, builder: (context){
                                        return const Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: Center(child: CircularProgressIndicator(),),
                                        );
                                      });
                                      state = await uploadWallpaper(widget.assetPath, "name");
                                    }
                                    //print("///////////////////////////////////////");
                                    
                                    if (state == "Success") {
                                      showsnackbar(context, "Uploaded");
                                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const ProfilePage()));
                                    }
                                  }, child:const Text("Continue"))
                                ],
                              ),
                            ),
                          );
                        });
                        // String state = "";
                        // while (state.isEmpty){
                        //   showDialog(context: context, builder: (context){
                        //     return const Dialog(
                        //       backgroundColor: Colors.transparent,
                        //       child: Center(child: CircularProgressIndicator(),),
                        //     );
                        //   });
                        //   state = await uploadWallpaper(widget.assetPath, "name");
                        // }
                        // Navigator.pop(context);
                        // if (state == "Success") {
                        //   showsnackbar(context, "Uploaded");
                        //   Navigator.pop(context);
                        // }
                        // showDialog(context: context, builder: (context){
                        //   TextEditingController controller = TextEditingController();
                        //   return Dialog(
                        //     child: Container(
                        //       padding:const EdgeInsets.all(10),
                        //       child: SingleChildScrollView(
                        //         child: Column(
                        //           children: [
                        //             TextField(
                        //               controller: controller,
                        //               decoration: InputDecoration(
                        //                 hintText: "Choose categories the vehicle is in",
                        //                 border: OutlineInputBorder(
                        //                   borderSide:const BorderSide(
                        //                     color: Colors.grey
                        //                   ),
                        //                   borderRadius: BorderRadius.circular(20)
                        //                 )
                        //               ),
                        //             ),
                        //             const Center(child: Text("Engine ",style: TextStyle(fontWeight: FontWeight.bold),)),
                        //             GridView.builder(
                        //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        //                 crossAxisCount: 2,
                        //                 childAspectRatio: 2.5
                        //               ),
                        //               itemCount: engine_Size.length,
                        //               shrinkWrap: true,
                        //               physics: const NeverScrollableScrollPhysics(),
                        //               itemBuilder: (BuildContext context, int index) {
                        //                 bool picked = false;
                        //                 return StatefulBuilder(
                        //                   builder: (context,enginestate) {
                        //                     return Row(
                        //                       children: [
                        //                          Text(engine_Size[index]),
                        //                         IconButton(onPressed: (){
                        //                           enginestate((){
                        //                             picked = !picked;
                        //                           });
                        //                         }, icon: Icon(
                        //                           picked?
                        //                           Icons.check_box:
                        //                           Icons.check_box_outline_blank))
                        //                       ],
                        //                     );
                        //                   }
                        //                 );
                        //               },
                        //             ),
                        //             const Center(child: Text("Brand",style: TextStyle(fontWeight: FontWeight.bold),),),
                        //             GridView.builder(
                        //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        //                 crossAxisCount: 2,
                        //                 childAspectRatio: 2.5
                        //               ),
                        //               itemCount: brands.length,
                        //               shrinkWrap: true,
                        //               physics: const NeverScrollableScrollPhysics(),
                        //               itemBuilder: (BuildContext context, int index) {
                        //                 bool picked = false;
                        //                   return StatefulBuilder(
                        //                     builder: (context,enginestate) {
                        //                       return Row(
                        //                         children: [
                        //                            Text(brands[index]),
                        //                           IconButton(onPressed: (){
                        //                             enginestate((){
                        //                               picked = !picked;
                        //                             });
                        //                           }, icon: Icon(
                        //                             picked?
                        //                             Icons.check_box:
                        //                             Icons.check_box_outline_blank))
                        //                         ],
                        //                       );
                        //                     }
                        //                   );
                        //               },
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // });
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
                          if (rotationAngle >90 && rotationAngle<=180) {
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
                StatefulBuilder(
                  builder: (context,buttonState) {
                    return IconButton(onPressed: ()async{
                      player.state == PlayerState.playing?
                     await player.pause():
                     await player.resume();
                     buttonState((){});
                    }, icon: Icon(
                      player.state == PlayerState.playing?
                      Icons.pause:
                      Icons.play_arrow,
                    size: 40,
                      ));
                  }
                )

              ],
            );
          }
        ),
        floatingActionButton: Container(
          width: 200,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: ()async{
                List category = [0,0,0];
                int selectededgine = 0;
                int selectedbrand = 0;
                int selectedtype = 0;
                TextEditingController search = TextEditingController();
                List filteredEngine = [];
                List filteredbrand = [];
                showDialog(context: context, builder: (context){
                  return Dialog(
                    child: SingleChildScrollView(
                      child: StatefulBuilder(
                        builder: (context,selectedtState) {
                          return Column(
                            children: [
                              const SizedBox(height: 10,),
                              const Text("Choose vehicle Category"),
                               Padding(padding:const EdgeInsets.all(20),
                              child: SearchBar(
                                controller: search,
                                hintText: "Search Category",
                                onChanged: (value){
                                  filteredEngine.clear();
                                  filteredbrand.clear();
                                  engine_Size.forEach((engine){
                                    if (engine.toLowerCase().contains(value.toLowerCase())) {
                                      filteredEngine.add(engine);
                                    }
                                  });
                                  brands.forEach((brand){
                                    if (brand.toLowerCase().contains(value.toLowerCase())) {
                                      filteredbrand.add(brand);
                                    }
                                  });
                                  selectedtState((){
                                    
                                  });
                                },
                              ),
                              
                              ),
                              const Text("Type"),
                              SizedBox(
                                width: 200,
                                height: 70,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: type.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) { 
                                    return Row(
                                      children: [
                                        Text(type[index],softWrap: true,),
                                        IconButton(onPressed: (){
                                          category[2] = index;
                                          selectedtState((){
                                            
                                            selectedtype = index;
                                          });
                                        }, icon: Icon(selectedtype==index?Icons.check_box:Icons.check_box_outline_blank))
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const Text("Engine Category"),
                              GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2.5
                                ),
                                itemCount:search.text.isEmpty? engine_Size.length:filteredEngine.length,
                                shrinkWrap: true,
                                padding:const EdgeInsets.only(left: 10),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    children: [
                                      Text(
                                        search.text.isEmpty?
                                        engine_Size[index]:
                                        filteredEngine[index]
                                        ,softWrap: true,),
                                      IconButton(onPressed: (){
                                        category[0] = index;
                                        selectedtState((){
                                          selectededgine = index;
                                        });
                                      }, icon:  Icon(selectededgine==index
                                      ?Icons.check_box: Icons.check_box_outline_blank))
                                    ],
                                  );
                                },
                              ),
                              const Text("Brand of vehicle"),
                              GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2.5
                                ),
                                itemCount:search.text.isEmpty? brands.length:filteredbrand.length,
                                shrinkWrap: true,
                                padding:const EdgeInsets.only(left: 10),
                                physics:const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    children: [
                                      Text(
                                        search.text.isEmpty?
                                        brands[index]:
                                        filteredbrand[index]
                                        ,softWrap: true,),
                                      IconButton(onPressed: (){
                                        category[1]  = index;
                                        selectedtState((){
                                          selectedbrand = index;
                                        });
                                      }, icon: Icon(selectedbrand==index
                                      ?Icons.check_box:Icons.check_box_outline_blank))
                                    ],
                                  );
                                },
                              ),
                              TextButton(onPressed: ()async{
                                String state = "";
                                while (state.isEmpty) {
                                  showcircularProgressIndicator(context);
                                  state =await UploadAudio(widget.assetPath, "name",category);
                                }
                                Navigator.pop(context);
                                if (state == "Success") {
                                  showsnackbar(context, "Successfully uploaded file");
                                  Navigator.pushAndRemoveUntil(context, (MaterialPageRoute(builder: (context)=> const Tunes())), (route)=>false);
                                }
                              }, child:const Text("Done"))
                            ],
                          );
                        }
                      ),
                    ),
                  );
                });
              }, icon:const Icon(Icons.check,color: Colors.white,)),
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon:const Icon(Icons.cancel,color: Colors.white,))
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    }
    
  }
}