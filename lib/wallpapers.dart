import 'dart:io';

import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/preview0.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_handler/wallpaper_handler.dart';

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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Collections",style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                FutureBuilder(
                  future: getWallpaperIds(),
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
                     //print(snapshot0.data!.length);
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: snapshot0.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool liked = false;
                        if (user !=null) {
                         liked =   snapshot0.data![index]["Likes"].contains(user!.uid);
                        }
                        
                        List likes = snapshot0.data![index]["Likes"];
                        return Card(
                          //color: const Color.fromARGB(6, 158, 158, 158),
                          color:Colors.transparent,
                          elevation: 0,
                          child: InkWell(
                            onTap: (){},
                            onLongPress: (){
                              
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FutureBuilder(
                                  future: getWallpaper(snapshot0.data![index].id),
                                  builder: (BuildContext context, AsyncSnapshot snapshot1) {
                                    if (snapshot1.connectionState == ConnectionState.waiting) {
                                      return const Center( child: CircularProgressIndicator(),);
                                    }
                                    return Expanded(
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(context, (MaterialPageRoute(builder: (context)=>PreviewWallpaper(bytes: snapshot1.data))));
                                        },
                                        onLongPress: (){
                                          showDialog(context: context, builder: (context){
                                            return Dialog(
                                              child: SizedBox(
                                                height: 250,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    TextButton(onPressed: ()async{
                                                      String filePath = File.fromRawPath(snapshot1.data).path;
                                                      await WallpaperHandler.instance.setWallpaperFromFile(filePath, WallpaperLocation.homeScreen);
                                                    }, child:const Text("Set Home Wallpaper")),
                                                    TextButton(onPressed: ()async{
                                                      String filePath = File.fromRawPath(snapshot1.data).path;
                                                      await WallpaperHandler.instance.setWallpaperFromFile(filePath, WallpaperLocation.lockScreen);
                                                    }, child:const Text("Set lockScreen Wallpaper")),
                                                    TextButton(onPressed: ()async{
                                                      String filePath = File.fromRawPath(snapshot1.data).path;
                                                      await WallpaperHandler.instance.setWallpaperFromFile(filePath, WallpaperLocation.bothScreens);
                                                    }, child:const Text("Set both Screens Wallpaper")),
                                                    TextButton(onPressed: (){}, child: const Text("Download")),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                        },
                                        child: Image(
                                        fit: BoxFit.fitWidth,
                                        image: MemoryImage(snapshot1.data)),
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    StatefulBuilder(
                                      builder: (context,likestate) {
                                        return Row(
                                          children: [
                                            IconButton(onPressed: (){
                                              liked?
                                              likes.remove(user!.uid):
                                              likes.add(user!.uid);
                                              liked = !liked;
                                              likeContent("wallpapers", snapshot0.data![index].id);
                                              likestate((){});
                                            }, icon: Icon(Icons.favorite,color: liked?Colors.red:null,)),
                                            Text(likes.length.toString()),
                                          ],
                                        );
                                      }
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(onPressed: (){}, icon: const Icon(Icons.download)),
                                          Text(snapshot0.data![index]["downloads"].toString()),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}