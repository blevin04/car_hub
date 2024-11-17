import 'package:flutter/material.dart';

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text("Match revs to their specific cars"),
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
                      child:const Text("Start",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
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
                  message: "Answer a few trivia questions to test you knowledge on cars",
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
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                  TextButton(
                    onPressed: (){},
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