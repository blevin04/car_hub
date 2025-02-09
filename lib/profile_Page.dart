import 'dart:ui';
import 'package:car_hub/authPage.dart';
import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/main.dart';
import 'package:car_hub/preview.dart';
import 'package:car_hub/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
List saved = [
  "lib/assets/m1.png",
  "lib/assets/img.jpg",
];
void themechange(BuildContext context) async {
  await Hive.box("theme").clear();
  if (darkmode) {
    await Hive.box("theme").put("theme", 1);
  } else {
    await Hive.box("theme").put("theme", 0);
  }
  print(Hive.box("theme").get("theme"));
}
List gridImages = ["lib/assets/rev_match_cover_0.jpeg","lib/assets/wallpaper_folder_.jpeg"];
List gridtitles = ["Rev Match","Add Collection"];
bool addopen = false;
bool darkmode = false;
class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    addopen = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        if (!snapshot.hasData) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  // title:const ("Profile",style: TextStyle(fontWeight: FontWeight.bold,),),
                      actions: [
                        TextButton(onPressed: ()async{
                         await FirebaseAuth.instance.signOut();
                        }, child:const Text("Log out")),
              StatefulBuilder(
                builder: (context,modestate) {
                  return IconButton(onPressed: (){
                      themechange(context);
                    if (darkmode)
                        {MyApp.of(context)!.changeTheme(ThemeMode.light);}
                      else
                        {MyApp.of(context)!.changeTheme(ThemeMode.dark);}
                        modestate(() {
                          darkmode = !darkmode;
                        });
                  }, icon: Icon(darkmode?Icons.dark_mode: Icons.sunny));
                }
              )
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: SizedBox(
                    height: 250,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image:const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("lib/assets/default_cover.png"))
                      ),
                    ),
                    Positioned(
                      top: 160,
                      left: 15,
                      child: InkWell(
                        onTap: (){
                          showDialog(context: context, builder: (context){
                            return const Image(image: AssetImage("lib/assets/default_cover.png"));
                          });
                        },
                        child:const CircleAvatar(
                          backgroundImage: AssetImage("lib/assets/default_profile.webp"),
                          radius: 40,
                        ),
                      ),
                    ),
                     const Positioned(
                      left: 100,
                      top: 200,
                      child: Padding(
                            padding:const EdgeInsets.all(8.0),
                            child: Text(
                              "User Name",
                              style:TextStyle(fontWeight: FontWeight.bold),),
                          ),
                      ),
                      Positioned(
                        right: 20,
                        top: 200,
                        child: 
                      IconButton(onPressed: (){}, icon:const Icon(Icons.edit))
                      )
                      ],
                    ),
                  ),
                ),
               const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        Text("🏎 Today's Random Fact  🏎",style: TextStyle(fontWeight: FontWeight.bold),),
                        Padding(
                          padding:  EdgeInsets.all(8.0),
                          child: Text("The Ford Mustang was originally going to be called the ""Cougar"" before Ford decided on its now-iconic name. The Mustang emblem even started as a stylized cat before it was changed to the galloping horse!"),
                        )
                      ],
                    ),
                  ),
                ),
               GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2,
                 ),
                 itemCount: 2,
                 itemBuilder: (BuildContext context, int index) {
                   return  Card(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(gridtitles[index],style:const TextStyle(fontWeight: FontWeight.bold),),
                        Container(
                         // padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          child: Image(
                            image: AssetImage(gridImages[index]))),
                         const Text("High Score: 200",style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ) ,
                   );
                 },
               ),
                       const Padding(
                padding:  EdgeInsets.all(4.0),
                child:  Text("Collections",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,decoration: TextDecoration.underline),),
              ),
               Visibility(
                child: GridView.builder(
                  shrinkWrap: true,
                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2,
                 ),
                 itemCount: 2,
                 itemBuilder: (BuildContext context, int index) {
                   return Card(
                    child: InkWell(
                      child: Column(
                        children: [
                          const Text("Collection Name.....",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          ),
                         const Image(image: AssetImage("lib/assets/default_profile.webp")),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:const EdgeInsets.all(3),
                                child:const Row(
                                  children: [
                                    Icon(Icons.person),
                                    Icon(Icons.person),
                                    Icon(Icons.person),
                                    Icon(Icons.person),
                                  ],
                                ),
              
                              ),
                             const Padding(
                                padding:  EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.download),
                                    Text("20"),
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
               ),)
              ],
                      ),
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                    floatingActionButton: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: StatefulBuilder(
              builder: (context,stateadd) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: addopen,
                      child: Column(
                      children: [
                        Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(child: IconButton(onPressed: (){}, icon: Icon(Icons.image))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(child: IconButton(onPressed: (){}, icon: Icon(Icons.music_note_rounded))),
                    ),
                      ],
                    )),
                    
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        child:IconButton(onPressed: (){
                        stateadd((){
                          addopen = !addopen;
                        });
                      }, icon:addopen? const Icon(Icons.cancel):const Icon(Icons.add))),
                    )
                  ],
                );
              }
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
                    child: Center(
                      child: Card(
                       child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Authpage()));
                        },
                      child: Container(
                       height: 200,
                        width: 200,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                             const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("LOG In",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              ),
                             const Text("Log in to you account or create an account "),
                             // const SizedBox(height: 20,),
                              Container(
                                height: 40,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                  
                                ),
                                child:const Text("Sign Up/Sign In",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              )
                          
                            ],
                          ),
                        ),
                      ),
                                      ),
                                    ),
                    ),
                  ),
            ],
          );
        }
        return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              minRadius: MediaQuery.of(context).size.width/4,
              backgroundImage:const AssetImage("lib/assets/CAR_HUB.png"),
              
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            ListTile(
              leading: Icon(Icons.circle),
              title: Text("Send feedback "),
            ),
            ListTile(
              leading: Icon(Icons.circle),
              title: Text("Contact Development team"),
            ),
            ListTile(
              leading: Icon(Icons.circle),
              title: Text("About App"),
            ),
            
            ListTile(
              onTap: ()async{
                showDialog(context: context, 
            builder: (context){
              return Dialog(
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    const  Text("Log out",style: TextStyle(fontWeight: FontWeight.bold),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(onPressed: ()async{
                           await FirebaseAuth.instance.signOut();
                          }, child:const Text("yes")),
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child:const Text("Cancel"))
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
              },
              title:const Text("Log Out"),
              leading:const Icon(Icons.exit_to_app_sharp),
            ),
          ],
        ),
      ),
      appBar: AppBar(
       //leadingWidth: 100,
        // leading: TextButton(onPressed: (){
            
        //   }, child:const Text("Log out")),
       title:const Text ("Profile",style: TextStyle(fontWeight: FontWeight.bold,),),
        actions: [
          
          StatefulBuilder(
            builder: (context,modestate) {
              return IconButton(onPressed: (){
                  themechange(context);
                if (darkmode)
                    {MyApp.of(context)!.changeTheme(ThemeMode.light);}
                  else
                    {MyApp.of(context)!.changeTheme(ThemeMode.dark);}
                    modestate(() {
                      darkmode = !darkmode;
                    });
              }, icon: Icon(darkmode?Icons.dark_mode: Icons.sunny));
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image:const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("lib/assets/default_cover.png"))
                      ),
                        ),
                      IconButton(
                        onPressed: ()async{
                          String newDp = await getContent(context, FileType.image);
                          if (newDp.isNotEmpty) {
                            String state =await setcover(newDp);
                            if (state == "Success") {
                              setState(() {});
                            }
                          }
                        }, 
                        icon:const Icon(Icons.edit,color: Colors.white,),
                        color: Colors.black,
                        )
                    ],
                  ),
                Positioned(
                  top: 160,
                  left: 15,
                  child: InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (context){
                        return  Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Center(
                              child: Image(image: 
                              Hive.box("UserData").containsKey("Dp")?
                              MemoryImage(Hive.box("UserData").get("Dp")):const
                              AssetImage("lib/assets/default_profile.webp")
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin:const EdgeInsets.only(bottom: 100),
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextButton(onPressed: ()async{
                                String newDp = await getContent(context, FileType.image);
                                if (newDp.isNotEmpty) {
                                  String state  = await setDp(newDp);
                                  if (state == "Success") {
                                    setState(() {
                                      
                                    });
                                  }
                                }
                              }, child:const Text("Edit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                            )
                          ],
                        );
                      });
                    },
                    child:FutureBuilder(
                      future: getDp(),
                      initialData:const AssetImage("lib/assets/default_profile.webp"),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return  CircleAvatar(
                            backgroundImage: snapshot.data,
                            radius: 40,
                          );
                      },
                    ),
                  ),
                ),
                 Positioned(
                  left: 100,
                  top: 200,
                  child: Padding(
                        padding:const EdgeInsets.all(8.0),
                        child: Text(
                          Hive.box("UserData").get("fullName"),
                          style:const TextStyle(fontWeight: FontWeight.bold),),
                      ),
                  ),
                  Positioned(
                    right: 20,
                    top: 200,
                    child: 
                  IconButton(onPressed: (){
                    showDialog(context: context, builder: (context){
                      TextEditingController controllerN = TextEditingController();
                      return Dialog(
                        child: Container(
                          height: 150,
                          //width: MediaQuery.of(context).size.width-100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                               Padding(
                                 padding: const EdgeInsets.all(12.0),
                                 child: TextField(
                                  controller:controllerN ,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12),
                                      
                                    ),
                                    hintText: "Name",
                                  ),
                                                               ),
                               ),
                              //const SizedBox(height: 20,),
                              TextButton(onPressed: ()async{
                                String state = await setName(controllerN.text);
                                if(state == "Success"){
                                  Navigator.pop(context);
                                  setState(() {});
                                }
                              }, child:const Text("Done"))
                            ],
                          ),
                        ),
                      );
                    });
                  }, icon:const Icon(Icons.edit))
                  )
                  ],
                ),
              ),
            ),
            Padding(
              padding:const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    const Text("🏎 Today's Random Fact  🏎",style: TextStyle(fontWeight: FontWeight.bold),),
                    Padding(
                      padding:const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: getFact(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          return Text(snapshot.data);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            
           GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
             ),
             itemCount: 2,
             itemBuilder: (BuildContext context, int index) {
               return  Card(
                child:InkWell(
                  onTap: () {
                    index==0?
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>const Revmatch()))
                    showsnackbar(context, "damn")
                    :
                    showDialog(context: context, builder: (context){
                      return Dialog(
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             const Text("Add Collection",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              TextButton(onPressed: (){}, 
                              child:const Text("New wellpaper collection"),

                              
                              ),
                              TextButton(onPressed: (){}, 
                              child:const Text("New tunes collection")
                              ),
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child:const Text("Cancel")
                              )
                            ],
                          ),
                        ),
                      );
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(gridtitles[index],style:const TextStyle(fontWeight: FontWeight.bold),),
                      Container(
                       // padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: Image(
                          image: AssetImage(gridImages[index]))),
                       const Text("High Score: 200",style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ) ,
               );
             },
           ),
           const SizedBox(height: 10,),

         const Padding(
            padding:  EdgeInsets.all(4.0),
            child:  Text("Collections",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,decoration: TextDecoration.underline),),
          ),
          const SizedBox(height: 10,),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            shrinkWrap: true,
            physics:const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              String img = index==0?"lib/assets/m1.png":"lib/assets/img.jpg";
              String title = index == 1?"Wallpaper":"Tunes";
              return Card(
                child: InkWell(
                  onTap: (){},
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  Text("Saved $title"),
                      ),
                      Expanded(
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(img)),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
           Visibility(
            child: GridView.builder(
              shrinkWrap: true,
             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
             ),
             itemCount: 2,
             physics: const NeverScrollableScrollPhysics(),
             itemBuilder: (BuildContext context, int index) {
               return Card(
                child: InkWell(
                  child: Column(
                    children: [
                     const Text("Collection Name.....",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                     const Image(image: AssetImage("lib/assets/default_profile.webp")),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding:const EdgeInsets.all(3),
                            child:const Row(
                              children: [
                                Icon(Icons.person),
                                Icon(Icons.person),
                                Icon(Icons.person),
                                Icon(Icons.person),
                              ],
                            ),

                          ),
                          const Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Row(
                              children: [
                                Icon(Icons.download),
                                Text("20"),
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
           ),)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: StatefulBuilder(
          builder: (context,stateadd) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: addopen,
                  child: Column(
                  children: [
                    Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(child: IconButton(onPressed: ()async{
                    showDialog(context: context, builder: (context){
                      return Dialog(
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            children: [
                              const Text("Upload Image",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                             const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child:  Text("Once you have uploaded the image you can share it via link "),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(onPressed: ()async{
                                    String imagePath = await getContent(context,FileType.image);
                                    Navigator.pop(context);
                                    Navigator.push(context, (MaterialPageRoute(builder: (context)=>Preview(assetPath: imagePath, isImage: true))));
                                  }, child:const Text("Upload")),
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: const Text("cancel")),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
                  }, icon:const Icon(Icons.image))),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(child: IconButton(onPressed: (){
                    showDialog(context: context, builder: (context){
                      return Dialog(
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            children: [
                               const Text("Upload audio",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                             const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child:  Text("Once you have uploaded the sound you can share it via link "),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(onPressed: ()async{
                                    String contentPath = await getContent(context, FileType.audio);
                                    Navigator.pop(context);
                                     Navigator.push(context, (MaterialPageRoute(builder: (context)=>Preview(assetPath: contentPath, isImage: false))));
                                  }, child:const Text("Upload")),
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: const Text("cancel")),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
                  }, icon:const Icon(Icons.music_note_rounded))),
                ),
                  ],
                )),
                
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    child:IconButton(onPressed: (){
                    stateadd((){
                      addopen = !addopen;
                    });
                  }, icon:addopen? const Icon(Icons.cancel):const Icon(Icons.add))),
                )
              ],
            );
          }
        ),
      ),
    );
      }
    );
    
  }
}