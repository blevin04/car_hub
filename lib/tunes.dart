import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

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
                child: Text("Categories",style: TextStyle(fontWeight: FontWeight.bold),),
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
          ),
          
          

        ],
      ),
    );
  }
}