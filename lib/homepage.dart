import 'package:car_hub/authPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
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
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("lib/assets/default_profile.webp"),
                      radius: 40,
                    ),
                    title: Text("Hello User Name ",style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("Lets Rev up"),
                  );
                }
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Authpage()));
                  },
                  child: Container(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("lib/assets/default_profile.webp"),
                        radius: 40,
                      ),
                      title: Text("Log In 🖐 ",style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text("Lets Rev up"),
                    ),
                  ),
                );
              },
            ),
            
            Card(
              elevation: 10,
              margin:const EdgeInsets.all(8),
              child: InkWell(
                child: Container(
                  //margin: EdgeInsets.all(2),
                 // padding: EdgeInsets.all(5),
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
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
                              Image(
                                fit: BoxFit.fill,
                                image: AssetImage("lib/assets/rev_match0.png")),
                                Text("High Score:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.yellow),),
                                Text("200",style: TextStyle(color: const Color.fromARGB(255, 255, 98, 0),fontWeight: FontWeight.bold,fontSize: 18),),
                                TextButton(onPressed: (){}, 
                                child: Card(
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
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
          ],
        ),
      ),
    );
  }
}