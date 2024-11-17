
import 'dart:ui';
import 'package:car_hub/authPage.dart';
import 'package:car_hub/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
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
                            padding: EdgeInsets.all(8.0),
                            child: Text("User Name",style: TextStyle(fontWeight: FontWeight.bold),),
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
                  padding: const EdgeInsets.all(8.0),
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
      
      appBar: AppBar(
        leadingWidth: 100,
        leading: TextButton(onPressed: (){
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
          }, child:const Text("Log out")),
       // title:const ("Profile",style: TextStyle(fontWeight: FontWeight.bold,),),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Text("User Name",style: TextStyle(fontWeight: FontWeight.bold),),
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
              padding: const EdgeInsets.all(8.0),
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
    );
      }
    );
    
  }
}