import 'package:audioplayers/audioplayers.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class Tunes extends StatefulWidget {
  const Tunes({super.key});

  @override
  State<Tunes> createState() => _TunesState();
}
List trending_sounds =[
  "0",
  "2",
  "3",
  "4"
];
AudioPlayer player =AudioPlayer();
class _TunesState extends State<Tunes> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(toolbarHeight: 40,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(
            leading: Icon(Icons.search),
            hintText: "Search for model ,eg:Supra",
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Trending Sounds",
              style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Card(
            child: CarouselSlider(
              items: trending_sounds.map((index){
                return InkWell(
                  child: Center(child: Text("sound number $index"),),
                );
              }).toList(), 
              options: CarouselOptions(
                autoPlay: true,
                height: 200
                )
              ),
          ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Pure Sounds",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              FutureBuilder(
                future: getTunes(),
                builder: (context,snapshot0) {
                  if (snapshot0.connectionState == ConnectionState.waiting) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: 2,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return const Card();
                      },
                    );
                  }
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot0.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      GifController gifController = GifController();

                      return Card(
                        child: Column(
                          children: [
                            GifView.asset(
                              controller: gifController,
                              "lib/assets/44zG.gif"
                              ),
                              IconButton(
                                onPressed: (){
                                  // player.setSource()
                                gifController.isPlaying?
                                gifController.stop():gifController.play();
                              }, icon:const Icon(Icons.play_circle_fill))
                          ],
                        ),
                      );
                    },
                  );
                }
              ),
              ],
            ),
          ),
          
          

        ],
      ),
    );
  }
}