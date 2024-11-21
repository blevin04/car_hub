import 'package:car_hub/gamePages/triviaPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class Revmatch extends StatefulWidget {
  const Revmatch({super.key});

  @override
  State<Revmatch> createState() => _RevmatchState();
}

class _RevmatchState extends State<Revmatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Card(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image:const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("lib/assets/rev_match0.png")),
                    borderRadius: BorderRadius.circular(15)
                  ),
                
                ),
                const Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: "Match revs with their respective cars ",
                  child: Icon(Icons.info),
                )
              ],
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
                          print(Hive.box("Score").values);
                          
                          
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
                    TextButton(onPressed: (){}, 
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
                      Navigator.push(context, (MaterialPageRoute(builder: (context)=>const Triviapage())));
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
        ],
      ),
    );
  }
}