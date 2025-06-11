import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/gamePages/revMatch.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void restartGame(){
  selected.value.clear();
  curState.value = gameStates[0];
  
}

class Vehiclematch extends StatefulWidget {
  const Vehiclematch({super.key});

  @override
  State<Vehiclematch> createState() => _VehiclematchState();
}

class _VehiclematchState extends State<Vehiclematch> {
  @override
  void dispose() {
    curState.value = gameStates[0];
    selected.value.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    curState.addListener((){
      if(curState.value==gameStates[0]){
        setState(() {
          
        });
      }
    });
    
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
          return gameScreen(snapshot.data,context);
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
ValueNotifier<Map> selected = ValueNotifier({});
List gameStates = ["feeding","completed","marked"];
  ValueNotifier<String >curState = ValueNotifier("feeding");

Widget gameScreen(Map<String,dynamic> gamedata,BuildContext context){
  PageController gamepagecontroller = PageController();
  int qnum = gamedata["raw"]!.length;
  DateTime initTime = DateTime.now();
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(onPressed: (){
        restartGame();
        Navigator.pop(context);
      }, icon:const Icon(Icons.arrow_back)),
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
        pageInfo.addAll({"soln":gamedata["soln"][gamedata["arrangement"][index]]});
        pageInfo.addAll({"qnum":qnum});
        return gamepageui(pageInfo,index);
      }),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    floatingActionButton: 
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: (){
            if (curState.value == gameStates[0]) {
                 gamepagecontroller.nextPage(duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
              }else if(
                curState.value == gameStates[1]
              ){
                double score = 0;
                Duration ttime = DateTime.now().difference(initTime);
                for (var i = 0; i < qnum; i++) {
                  if (selected.value[i].toString().trim() == gamedata["soln"][gamedata["arrangement"][i]].toString().trim()) {
                   
                    score+=10;
                  }
                }
                if (ttime.inMinutes < 1) {
                  score+=10;
                }else
                if (ttime.inMinutes <5) {
                  score+=5;
                }
                curState.value = gameStates[2];
                showScore(score, context);
                UpdateHighScore(score, 2);
              }else{
                restartGame();
              }
          },
          
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width-80,
            height: 60,
            // padding:const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20)
            ),
            child:ListenableBuilder(
              listenable: curState,
              builder: (context,child) {
                return curState.value == gameStates[0]? const Text("Next",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),):
                  curState.value == gameStates[1]?const Text("Finish",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),):
                  const Text("Play Again",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),)
                ;
              }
            ),
          ),
        ),
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
Map imageCache = {};
Widget gamepageui(Map pageinfo,int pageNum){
  String soln = pageinfo["soln"];
  ValueNotifier newselection0 = ValueNotifier(0);
  return SingleChildScrollView(
    child: Column(
      children: [
        ListenableBuilder(
          listenable: curState,
          builder: (context,child) {
            
            return Card(
              child: Image(image:
              curState.value == gameStates[0]?
               MemoryImage(pageinfo["images"].first):
               curState.value == gameStates[1]?
               MemoryImage(pageinfo["images"].first):
               MemoryImage(pageinfo["images"].last)
               ),
            );
          }
        ),
        const SizedBox(height: 20,),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: 4,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            String choice = pageinfo["choices"][index];
            // print("${choice.codeUnits} : ${soln.codeUnits} ${choice.trim() == soln.trim()}");
            return ListenableBuilder(
              listenable:Listenable.merge([curState,newselection0]),
              builder: (context,child) {
                return Card(
                  child: InkWell(
                    onTap: (){
                      selected.value.update(pageNum, (value)=>choice,ifAbsent: () => choice,);
                      if (selected.value.length>=pageinfo["qnum"]) {
                        curState.value = gameStates[1];
                      }
                      newselection0.value++;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 5,
                          color: curState.value == gameStates[2]?
                          choice.trim() == soln.trim()?
                          Colors.green:
                          selected.value[pageNum] == choice?
                          Colors.red:
                          Colors.transparent
                          :
                        // selected.value[pageNum] == choice?
                        // selected.value[pageNum] == soln?
                        // Colors.green:Colors.red:Colors.transparent:
                        selected.value[pageNum] == choice?
                        Colors.blue:Colors.transparent) 
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          imageCache.containsKey(choice)?
                           Expanded(child: Image(image: MemoryImage(imageCache[choice]))):
                          FutureBuilder(
                            future: fetchLogo(choice),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data.isEmpty) {
                                return  const Expanded(
                                  child: Image(image: AssetImage("lib/assets/carIcon.png"))
                                );
                              }
                              // print(snapshot.data);
                                if(!imageCache.containsKey(choice)){
                                  imageCache.addAll({choice:snapshot.data});
                                  return Expanded(child: Image(image: MemoryImage(snapshot.data)));
                                }else{
                                  return Expanded(child: Image(image: MemoryImage(imageCache[choice])));
                                }
                            },
                          ),
                          Text(choice,style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                        ],
                      ),
                    ),
                  ),
                );
              }
            );
          },
        ),

      ],
    ),
  );
}