
import 'dart:typed_data';

import 'package:car_hub/backendFxns.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Vehiclematch extends StatelessWidget {
  const Vehiclematch({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FutureBuilder(
        future: pre_Maksed(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScreen();
          }
          if (snapshot.data == null || snapshot.data == {}) {
            return errorMassage();
          }
          return gameScreen(snapshot.data);
        },
      ),
    );
  }
}

Widget loadingScreen (){

  return Scaffold(
    backgroundColor: Colors.black,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.blue, size: 40)),
        const Center(child: Text("Loading your experience....",style: TextStyle(color: Colors.white),))
      ],
    ),
  );
}

Widget gameScreen(Map<String,dynamic> gamedata){
  PageController gamepagecontroller = PageController();
  int qnum = gamedata["raw"]!.length;
  return Scaffold(
    appBar: AppBar(
      title:const Text("Masked Madness"),
      actions: [
        // ListenableBuilder(
        //   listenable: gamepagecontroller,
        //   builder: (context,child) {
        //     return Text(
        //       gamepagecontroller.hasClients?
        //       "${gamepagecontroller.page!.ceil()+1 }/${qnum.toString()}":"1:${qnum.toString()}");
        //   }
        // ),
        IconButton(onPressed: (){}, icon:const Icon(Icons.info))
      ],
    ),
    body: PageView(
      controller:gamepagecontroller ,
      children: List.generate(qnum, (index){
        Map pageInfo = {};
        pageInfo.addAll({"images":[gamedata["masked"]![index],gamedata["raw"]![index]]});
        
        pageInfo.addAll({"choices":gamedata["choices"][gamedata["arrangement"][index]]});
        
        return gamepageui(pageInfo);
      }),
    ),
  );
}
Widget errorMassage(){

  return Scaffold(
    appBar: AppBar(),
    body:const Column(
      children: [
        Center(child: Icon(Icons.error,color: Colors.red,)),
        Center(child: Text("An error occured please check your internet connection and try again"))
      ],
    )
  );
}

Widget gamepageui(Map pageinfo){
  print(pageinfo["choices"]);
  return SingleChildScrollView(
    child: Column(
      children: [
        Card(
          child: Image(image: MemoryImage(pageinfo["images"].first)),
        ),
        SizedBox(height: 20,),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: 4,
          shrinkWrap: true,

          itemBuilder: (BuildContext context, int index) {
            String choice = pageinfo["choices"][index];
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FutureBuilder(
                    future: fetchLogo(choice),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data.isEmpty) {
                        return  Expanded(
                          child: Image(image: AssetImage("lib/assets/carIcon.png"))
                        );
                      }
                      // print(snapshot.data);
                    
                        return Center(
                        child: Image(image: MemoryImage(snapshot.data)),
                      );
                    
                      
                    },
                  ),
                  Text(choice,style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}