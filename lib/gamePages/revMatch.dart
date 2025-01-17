import 'dart:async';

import 'package:car_hub/profile_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gif_view/gif_view.dart';

class Revmatch extends StatefulWidget {
  const Revmatch({super.key});

  @override
  State<Revmatch> createState() => _RevmatchState();
}
GifController gifController = GifController(
  autoPlay: false
);
class _RevmatchState extends State<Revmatch> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      // initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(225, 37, 35, 35),
            body: Container(
              height: MediaQuery.of(context).size.height,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.cover,
              //     image: AssetImage("lib/assets/revmatchBackground.png"))
              // ),
              child: Animate(
                onComplete: (controller){
                  controller.reverse();
                },
              effects: [FadeEffect(
                begin: 0.7,
                end: 0.9,
                duration: Duration(seconds: 1)
              )],
              delay: Duration(seconds: 0),
              child: Image(image: AssetImage("lib/assets/rev_match0.png"))
              )
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(

          ),
          body: Column(
            children: [
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GifView.asset(
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        controller: gifController,
                        "lib/assets/44zG.gif"),
                
                        IconButton(onPressed: (){
                
                      },
                       icon:const Icon(Icons.play_arrow,color: Colors.white,size: 40,))
                    ],
                  ),
                
                ),
              ),
              const SizedBox(height: 50,),
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text("Answer")),
                        ),
                        Card(
                          child:  Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text("Answer")),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Card(
                          child:  Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text("Answer")),
                        ),
                        Card(
                          child:  Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text("Answer")),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 50,
                alignment: Alignment.center,
                margin:const EdgeInsets.all(20),
                // padding: EdgeInsets.only(left: 10,:10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue
                ),
                child:const Text("Skip",style: TextStyle(fontSize: 20),),
              )
            ],
          ),
        );
      },
    );
  }
}