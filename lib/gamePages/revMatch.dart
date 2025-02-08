import 'package:audioplayers/audioplayers.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

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
  loop: true,
);

ValueNotifier<bool> startUpDone = ValueNotifier(false);
PageController pageControllerG = PageController();
AudioPlayer audioPlayerG = AudioPlayer();
class _RevmatchState extends State<Revmatch> {
  int currPage = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageControllerG = PageController();
    pageControllerG.addListener((){
      currPage = pageControllerG.page!.toInt()+1;
    }); 
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: preGame(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(225, 37, 35, 35),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     fit: BoxFit.cover,
          //     image: AssetImage("lib/assets/revmatchBackground.png"))
          // ),
          child: GifView.asset(
            controller: _gifController,
            "lib/assets/startup_gif.gif"
            )
        ),
      );
    }

    Map<String,dynamic> tunesData = snapshot.data;
    List tuneKeys = tunesData.keys.toList();
    return Scaffold(
      appBar: AppBar(
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
          return Column(
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
              
                      IconButton(onPressed: ()async{
                        if (audioPlayerG.state == PlayerState.playing) {
                          audioPlayerG.pause();
                          gifController.pause();
                        }else{
                          audioPlayerG.play(BytesSource(tunesData[tuneKeys[index]]["MP3"]));
                          gifController.play();
                        }
                      // print(tunesData[tuneKeys[index]]);
                    },
                     icon:ListenableBuilder(
                      listenable: gifController, 
                      builder: (context,child){
                        return  Icon(
                          gifController.isPlaying?
                          Icons.pause:
                          Icons.play_arrow,color: Colors.white,size: 40,);
                      }) )
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
                          padding:const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Text("Answer")),
                      ),
                      Card(
                        child:  Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Text("Answer")),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        child:  Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Text("Answer")),
                      ),
                      Card(
                        child:  Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Text("Answer")),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        );
        })
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