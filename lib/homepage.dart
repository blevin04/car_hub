import 'package:car_hub/authPage.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/gamePages/revMatch.dart';
import 'package:car_hub/gamePages/triviaPage.dart';
import 'package:car_hub/gamePages/vehicleMatch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:car_hub/ad_helper.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}
class _HomepageState extends State<Homepage> {
  BannerAd? _bannerAd;
  @override
  void initState() {
     super.initState();
  BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    request: AdRequest(),
    size: AdSize.banner,
    listener: BannerAdListener(
      onAdLoaded: (ad) {
        setState(() {
          _bannerAd = ad as BannerAd;
        });
      },
      onAdFailedToLoad: (ad, err) {
        print('Failed to load a banner ad: ${err.message}');
        ad.dispose();
      },
    ),).load();
   
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 20,),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return FutureBuilder(
                        future: getUserData(),
                        //initialData: InitialData,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return  ListTile(
                                leading:const CircleAvatar(
                                  //backgroundImage: AssetImage("lib/assets/default_profile.webp"),
                                  radius: 40,
                                ),
                                title: Container(
                                  height: 20,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:const Text(""),
                                ),
                                subtitle:Container(
                                  height: 20,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:const Text(""),
                                )
                              );
                          }
                          if (snapshot.data == null) {
                            return  ListTile(
                                leading:const CircleAvatar(
                                  //backgroundImage: AssetImage("lib/assets/default_profile.webp"),
                                  radius: 40,
                                ),
                                title: Container(
                                  height: 20,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:const Text(""),
                                ),
                                subtitle:Container(
                                  height: 20,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:const Text(""),
                                )
                              ); 
                          }
                          String userName = snapshot.data!["fullName"];
                          bool hasDp = snapshot.data!.containsKey("Dp");
                          var dpData ;
                          if (hasDp) {
                            dpData = snapshot.data!["Dp"];
                          }
                          return ListTile(
                            onTap: () {
                           
                            },
                        leading: CircleAvatar(
                          backgroundImage:hasDp?
                          MemoryImage(dpData):
                          const AssetImage("lib/assets/default_profile.webp"),
                          radius: 40,
                        ),
                        title: Text("Hello $userName ",style:const TextStyle(fontWeight: FontWeight.bold),),
                        subtitle:const Text("Lets Rev up"),
                      );
                        },
                      );
                    }
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Authpage()));
                      },
                      child:const ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("lib/assets/default_profile.webp"),
                          radius: 40,
                        ),
                        title: Text("Log In 🖐 ",style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text("Lets Rev up"),
                      ),
                    );
                  },
                ),
                
                Card(
                  elevation: 10,
                  margin:const EdgeInsets.all(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      //margin: EdgeInsets.all(2),
                     // padding: EdgeInsets.all(5),
                      //height: 250,
                      width: MediaQuery.of(context).size.width-10,
                      decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.circular(15)
                        ),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          GifView.asset(
                            controller: GifController(loop: false,onFinish: (){}),
                            fit: BoxFit.fill,
                            repeat: ImageRepeat.noRepeat,
                            "lib/assets/startup_gif.gif"),
                          // Card(
                          //   margin:const EdgeInsets.all(0),
                          //   color: const Color.fromARGB(81, 255, 255, 255),
                          //   child: Container(
                          //     padding:const EdgeInsets.all(0),
                          //     height: 200,
                          //     width: 130,
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: [
                          //        const Image(
                          //           fit: BoxFit.fill,
                          //           image: AssetImage("lib/assets/rev_match0.png")),
                          //          const Text("High Score:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.yellow),),
                          //          const Text("200",style: TextStyle(color:  Color.fromARGB(255, 255, 98, 0),fontWeight: FontWeight.bold,fontSize: 18),),
                          //           TextButton(onPressed: ()async{
                          //             // await Navigator.push(context, MaterialPageRoute(builder: (context)=>const Revmatch()));
                          //           }, 
                          //           child: const Card(
                          //             margin: EdgeInsets.all(0),
                          //             color: Colors.blue,
                          //             child: Padding(
                          //               padding: EdgeInsets.all(8.0),
                          //               child: Row(
                          //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //                 children: [
                          //                   Text("Play"),
                          //                   Icon(Icons.play_arrow)],
                          //                   ),
                          //             ),))
                          //       ],
                          //     )
                          //   )
                          // ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width-20,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                       Column(
                        children: [
                         const Text("High Score",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          FutureBuilder(
                            future:getScore(0),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator(),);
                              }
                              
                              return ListenableBuilder(
                                listenable: Hive.box("Score").listenable(),
                                 builder: (context,child){
                                  return Text(snapshot.data.roundToDouble().toString(),style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 20));
                                 });
                            },
                          ),
                        ],
                      ),
                        TextButton(onPressed: (){
                          if (FirebaseAuth.instance.currentUser == null) {
                            showDialog(context: context, builder: (context){
                              return Dialog(
                                child: Card(
                                  
                                  child: SizedBox(
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("You need to Log in First to play a game"),
                                        TextButton(onPressed: (){
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Authpage()));
                                        }, child:const Text("LogIn / SignUp"))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          }else{
                            Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Revmatch())));
                          }
                          
                        }, 
                        child: Container(
                          width: 100,
                          height: 40,
                          //padding:const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                            
                          ),
                          child:const Text("Start",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
                Card(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image:const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("lib/assets/carTrivia.png"))
                      ),
                    ),
                    const Tooltip(
                      triggerMode: TooltipTriggerMode.tap,
                      message: "Answer a few trivia questions to test you knowledge on cars the faster you answer all the questions the better your score",
                      child: Icon(Icons.info),
                    )
                  ],
                ),
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      //height: 150,
                      padding:const EdgeInsets.all(10),
                      width: 200,
                      decoration: BoxDecoration(
                        //color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text("High Score",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          FutureBuilder(
                            future: getScore(1),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              // if (snapshot.data) {
                              //   return const Text("00",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                              // }
                              return Text(snapshot.data.toString(),style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold));
                            },
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: ()async{
                        // await triviaStart();
                        if (FirebaseAuth.instance.currentUser == null) {
                          showDialog(context: context, builder: (context){
                            return Dialog(
                              child: Card(
                                
                                child: SizedBox(
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("You need to Log in First to play a game"),
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Authpage()));
                                      }, child:const Text("LogIn / SignUp"))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        }else{
                          showDialog(context: context, builder: (builder){
                          return Dialog(
                            child: SizedBox(
                              height: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Select difficulty"),
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Triviapage(duration:80 ,))));
                                  }, child:const Text("Easy")),
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Triviapage(duration: 70,))));
                                  }, child:const Text("Mediaum")),
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Triviapage(duration: 60,))));
                                  }, child:const Text("Hard")),
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Triviapage(duration: 50,))));
                                  }, child: const Text("Petrol addict")),
                                ],
                              ),
                            ),
                          );
                        });
                        }
                        
                        
                      },
                     child:Container(
                      height: 40,
                      width: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child:const Text("Play",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 19),),
                     ) )
                  ],
                ),
              ),
              // masked Maddness
              Card(
                child:ListTile(
                  onTap: (){
                    Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Vehiclematch())));
                  },
                  leading:const Icon(Icons.car_crash,color: Colors.black,size: 25,),
                  title:const Text("Masked Maddness"),
                  subtitle:const Text("How well do you know your cars bodies"),
                  trailing:FutureBuilder(
                    future: getScore(2),
                    initialData: 00,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return  Text("score:${snapshot.data.ceil()}",style:const TextStyle(fontSize: 18,color: Colors.black),);
                    },
                  ),
                )
              ),
              //logo legend
              // Card(
              //   child:ListTile(
              //     onTap: (){
              //       Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Logolegend())));
              //     },
              //     leading:const Icon(Icons.question_mark_outlined),
              //     title:const Text("Play Lego Legend"),
              //     subtitle:const Text("How well do you know your cars brand logos"),
              //     trailing: Text("score:00",style: TextStyle(fontSize: 18),),
              //   )
              // )
                // TextButton(onPressed: (){
                //   openShit();
                // }, child: Text("openshit"))
                // AspectRatio(aspectRatio: aspectRatio)
              ],
            ),
          ),
          if (_bannerAd != null)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
      // floatingActionButton: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.userChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting){
      //       return Container();
      //     }
      //     if (snapshot.hasData) {
      //       return Container(
      //       //padding:const EdgeInsets.all(6),
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(20),
      //         color: Colors.green
      //       ),
      //       child:TextButton(
      //         onPressed: ()async{
      //           await Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Chatrooms())));
      //         }, 
      //       child: const Text("Chatrooms",style: TextStyle(color: Colors.white),)),
      //     );
      //     }else{
      //       return Container();
      //     }
      //   }
      // ),
    );
  }
}