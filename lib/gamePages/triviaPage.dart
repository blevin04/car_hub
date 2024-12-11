import 'dart:convert';

import 'package:car_hub/backendFxns.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class Triviapage extends StatefulWidget {
  final int duration;
  const Triviapage({super.key,required this.duration});
static PageController controller = PageController();

  @override
  State<Triviapage> createState() => _TriviapageState();
}

class _TriviapageState extends State<Triviapage> {
  @override
  Widget build(BuildContext context) {
    ValueNotifier allfilled = ValueNotifier(0);
    bool completed = false;
    CountDownController countDownController = CountDownController();
    Map selected ={};
    Map answersAll = {};
    bool hasdata = false;
    return  Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: ()async{
          if (!hasdata) {
            setState(() {
            
          });
          }
          if (completed) {
            setState(() {
              
            });
          }
        },
        child: FutureBuilder(
          future: triviaStart(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.blue, size: 40));
            }
            //print(snapshot.data);
            if (snapshot.hasData) {
              hasdata = true;
              return StatefulBuilder(
                builder: (context,pagestateAll) {
                  return Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: Triviapage.controller,
                          children: List.generate(snapshot.data.length, (index){
                            Map Quiz = snapshot.data[index.toString()];
                            String question = Quiz["question"];
                             List choices =[];
                            if (Quiz.containsKey("choice")) {
                              choices = Quiz["choice"];
                            }else{
                                choices = Quiz["choices"];
                            }
                            String answer = Quiz["answer"];
                            int answeIndex = choices.indexOf(answer);
                            if (!answersAll.containsKey(index)) {
                               answersAll.addAll({index:answeIndex});
                            }
                            //List choiceKeys = ["a","b","c","d"];
                            return SingleChildScrollView(
                              child: StatefulBuilder(
                                builder: (context,pagestate) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text("Question ${index+1}/10"),
                                        trailing: SizedBox(
                                          width: 130,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(onPressed: (){
                                                Triviapage.controller.animateToPage((Triviapage.controller.page!).toInt()-1, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
                                              }, icon:const Icon(Icons.keyboard_arrow_left)),
                                              IconButton(onPressed: (){
                                                 Triviapage.controller.animateToPage((Triviapage.controller.page!).toInt()+1, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
                                              }, icon:const Icon(Icons.keyboard_arrow_right)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                        child: LinearProgressIndicator(
                                          minHeight: 5,
                                          borderRadius: BorderRadius.circular(10),
                                          value: (index+1)/10,
                                          valueColor:const AlwaysStoppedAnimation(Colors.blue),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          padding:const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Text(question,style:const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                      const SizedBox(height: 40,),
                                      StatefulBuilder(
                                        builder: (context,choiseState) {
                                          return ListView.builder(
                                            padding:const EdgeInsets.only(bottom: 30),
                                            itemCount: choices.length,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context, int index1) {
                                              
                                              return Card(
                                                margin:const EdgeInsets.all(10),
                                                color: selected.containsKey(index)?
                                                selected[index]==index1?
                                                completed?
                                                answer == choices[index1]?
                                                Colors.green:Colors.red
                                                :Colors.blue:
                                                completed?
                                                answer == choices[index1]?
                                                Colors.green:
                                                null:null:null
                                                
                                                ,
                                                child: ListTile(
                                                  onTap: (){
                                                    //print(selected.length);
                                                    if (selected.length>=9) {
                                                      allfilled.value=1;
                                                    }
                                                    completed?null:
                                                    choiseState((){
                                                      selected.update(index, (value)=>index1,ifAbsent: ()=>index1);
                                                    });
                                                  },
                                                  title: Text(choices[index1]),
                                                  trailing: Icon(
                                                    selected.containsKey(index)?
                                                    selected[index] == index1?
                                                    Icons.check_circle:
                                                   Icons.circle_outlined:Icons.circle_outlined),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      ),
                                      const SizedBox(height: 15,),
                                      
                                    ],
                                  );
                                }
                              ),
                            );
                          }),
                        ),
                      ),
                      completed?
                      Card(
                        child: Builder(
                          builder: (context) {
                            double score = 0;
                            // print(answersAll);
                            // print(selected);
                            selected.forEach(
                              (key, value) {
                              if (answersAll[key]==value) {
                                score++;
                              }
                            },);
                            score = (score*8)+jsonDecode(countDownController.getTime()!);
                            
                            UpdateHighScore(score.toDouble());
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("$score/100 ",style:const TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                            );
                          }
                        ),
                      )
                      :CircularCountDownTimer(
                        width: 180, 
                        height: 180, 
                        duration: widget.duration, 
                        fillColor: const Color.fromARGB(161, 17, 0, 255), 
                        ringColor:  const Color.fromARGB(40, 33, 149, 243),
                        backgroundColor: Colors.blue,
                        strokeWidth: 20,
                        strokeCap: StrokeCap.round,
                        textStyle:const TextStyle(color: Colors.white,fontSize: 20),
                        textFormat: CountdownTextFormat.S,
                        controller: countDownController,
                        isReverse: true,
                        onComplete: (){
                          pagestateAll(() {
                            completed = true;
                          });
                          
                        },
                        ),
                        const SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          if (completed) {
                                print("lllll");
                                setState(() {
                                  
                                });
                              }
                              if (allfilled.value == 1) {
                                print("kkkkk");
                                countDownController.pause();
                                pagestateAll((){
                                  completed = true;
                                });
                              }else{
                                 Triviapage.controller.animateToPage((Triviapage.controller.page!).toInt()+1, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
                              }
                              
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width-80,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          
                             child: 
                          ListenableBuilder(
                            listenable: allfilled, 
                            builder: (context,child){
                              Widget button = Container();
                              // print(allfilled.value);
                              if (allfilled.value == 1 && !completed)  {
                                return button =  const Text("Finish",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),);
                              }
                              if (allfilled.value == 0 && !completed) {
                                return  const Text("Continue",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),);
                              }
                              if (completed) {
                                return const Text("Play Again",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),);
                              }
                              return  button;
                            })
                          
                           
                        ),
                      ),
                      const SizedBox(height: 20,)
                    ],
                  );
                }
              );
            }
            return Center(child: InkWell(
              onTap: () {
                setState(() {
                });
              },
              child:const Text("Error occured please refresh the page")),);
          },
        ),
      ),
    );
  }
}