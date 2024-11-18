import 'package:car_hub/backendFxns.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class Triviapage extends StatelessWidget {
  const Triviapage({super.key});
static PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: triviaStart(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.blue, size: 40));
          }
          print(snapshot.data);
          if (snapshot.hasData) {
            return PageView(
              controller: controller,
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
                //List choiceKeys = ["a","b","c","d"];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Question $index/10"),
                        trailing: SizedBox(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(onPressed: (){
                                controller.animateToPage((controller.page!).toInt()-1, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
                              }, icon:const Icon(Icons.keyboard_arrow_left)),
                              IconButton(onPressed: (){
                                 controller.animateToPage((controller.page!).toInt()+1, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
                              }, icon:const Icon(Icons.keyboard_arrow_right)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(10),
                          value: index/10,
                          valueColor:const AlwaysStoppedAnimation(Colors.blue),
                        ),
                      ),
                      Card(
                        child: Container(
                          padding:const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(question),
                        ),
                      ),
                      const SizedBox(height: 40,),
                      ListView.builder(
                        padding:const EdgeInsets.only(bottom: 30),
                        itemCount: choices.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index1) {
                          return Card(
                            margin:const EdgeInsets.all(10),
                            child: ListTile(
                              onTap: (){},
                              title: Text(choices[index1]),
                              trailing:const Icon(Icons.check_circle_outline_sharp),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 50,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextButton(onPressed: (){
                           controller.animateToPage((controller.page!).toInt()+1, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
                        }, child: 
                        const Text("Continue",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                      )
                    ],
                  ),
                );
              }),
            );
          }
          return const Center(child: Text("Error occured please refresh the page"),);
        },
      ),
    );
  }
}