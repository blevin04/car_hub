import 'package:car_hub/authPage.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/chatrooms.dart';
import 'package:car_hub/gamePages/revMatch.dart';
import 'package:car_hub/gamePages/triviaPage.dart';
import 'package:car_hub/revMatch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gif_view/gif_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}
final gemini = Gemini.instance;
void openShit()async{
  gemini.text("random car fact").then((onValue){
    print(onValue?.output);
  });
}
class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages
      if (message.notification != null) {
        print("Notification Title: ${message.notification!.title}");
        print("Notification Body: ${message.notification!.body}");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 20,),
      body: SingleChildScrollView(
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
                      String userName = snapshot.data!["fullName"];
                      bool hasDp = snapshot.data!.containsKey("Dp");
                      var dpData ;
                      if (hasDp) {
                        dpData = snapshot.data!["Dp"];
                      }
                      return ListTile(
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
                      Card(
                        margin:const EdgeInsets.all(0),
                        color: const Color.fromARGB(81, 255, 255, 255),
                        child: Container(
                          padding:const EdgeInsets.all(0),
                          height: 200,
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                             const Image(
                                fit: BoxFit.fill,
                                image: AssetImage("lib/assets/rev_match0.png")),
                               const Text("High Score:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.yellow),),
                               const Text("200",style: TextStyle(color:  Color.fromARGB(255, 255, 98, 0),fontWeight: FontWeight.bold,fontSize: 18),),
                                TextButton(onPressed: ()async{
                                  // await Navigator.push(context, MaterialPageRoute(builder: (context)=>const Revmatch()));
                                }, 
                                child: const Card(
                                  margin: EdgeInsets.all(0),
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Play"),
                                        Icon(Icons.play_arrow)],
                                        ),
                                  ),))
                            ],
                          )
                        )
                      ),
                      
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
                        future: Hive.openBox("Score"),
                        
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          double score = 0;
                          return ListenableBuilder(
                            listenable: Hive.box("Score").listenable(),
                            builder: (context,child) {
                              if (!Hive.box("Score").containsKey("RevMatch")) {
                            return const Text("00",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),);
                            }else{
                              score = Hive.box("Score").get("RevMatch");
                            }
                              return Text(score.toString(),style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),);
                            }
                          );
                        },
                      ),
                    ],
                  ),
                    TextButton(onPressed: (){
                      Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Revmatch())));
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
            child: Container(
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
                          future: Hive.openBox("Score"),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.data.isEmpty) {
                              return const Text("00",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                            }
                            return Text(snapshot.data.get("CarTrivia").toString());
                          },
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: ()async{
                      // await triviaStart();
                      showDialog(context: context, builder: (builder){
                        return Dialog(
                          child: Container(
                            height: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text("Select difficulty"),
                                TextButton(onPressed: (){
                                  Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Triviapage(duration:80 ,))));
                                }, child:const Text("Easy")),
                                TextButton(onPressed: (){
                                  Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Triviapage(duration: 70,))));
                                }, child:const Text("Mediaum")),
                                TextButton(onPressed: (){
                                  Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Triviapage(duration: 60,))));
                                }, child:const Text("Hard")),
                                TextButton(onPressed: (){
                                  Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Triviapage(duration: 50,))));
                                }, child: const Text("Petrol Head")),
                              ],
                            ),
                          ),
                        );
                      });
                      
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
          )
            // TextButton(onPressed: (){
            //   openShit();
            // }, child: Text("openshit"))
            // AspectRatio(aspectRatio: aspectRatio)
          ],
        ),
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