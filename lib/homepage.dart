import 'package:car_hub/authPage.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/gamePages/chatrooms.dart';
import 'package:car_hub/revMatch.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gif_view/gif_view.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 20,),
      body: SingleChildScrollView(
        child: Column(
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
                  height: 250,
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
                                  await Navigator.push(context, MaterialPageRoute(builder: (context)=>const Revmatch()));
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
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return Card();
              },
            ),
            // TextButton(onPressed: (){
            //   openShit();
            // }, child: Text("openshit"))
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Container();
          }
          if (snapshot.hasData) {
            return Container(
            //padding:const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.green
            ),
            child:TextButton(
              onPressed: ()async{
                await Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Chatrooms())));
              }, 
            child: const Text("Chatrooms",style: TextStyle(color: Colors.white),)),
          );
          }else{
            return Container();
          }
          
        }
      ),
    );
  }
}