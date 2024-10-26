import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Wallpapers extends StatefulWidget {
  const Wallpapers({super.key});

  @override
  State<Wallpapers> createState() => _WallpapersState();
}
List trending_wallpapers = ["1","2","3","4","5"];
class _WallpapersState extends State<Wallpapers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 30,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SearchBar(
              leading: Icon(Icons.search),
              hintText: "Seach for brand model eg,Porshe GT3RS",
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Trending Wallpapers",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Card(
                  child: 
                  CarouselSlider(
                    items: trending_wallpapers.map((index){
                      return InkWell(
                        child: Center(child: Text("wallpaper number $index"),),
                      );
                    }).toList(),
                     options: CarouselOptions(height: 200,autoPlay: true),

                     ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Collections",style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
          )
        ],
      ),
    );
  }
}