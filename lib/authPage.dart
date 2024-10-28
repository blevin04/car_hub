import 'package:car_hub/firebasemethods.dart';
import 'package:car_hub/mobile_layout.dart';
import 'package:flutter/material.dart';
class Authpage extends StatefulWidget {
  const Authpage({super.key});

  @override
  State<Authpage> createState() => _AuthpageState();
}
PageController pagecontroller = PageController();
TextEditingController loginEmail = TextEditingController();
TextEditingController loginPassword = TextEditingController();
TextEditingController name = TextEditingController();
TextEditingController signupEmail = TextEditingController();
TextEditingController signUpPassword = TextEditingController();
TextEditingController signUpPasswordconfirm = TextEditingController();
class _AuthpageState extends State<Authpage> {
  @override
  void dispose() {
    pagecontroller.dispose();
    loginEmail.dispose();
    loginPassword.dispose();
    name.dispose();
    signUpPassword.dispose();
    signUpPasswordconfirm.dispose();
    signupEmail.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pagecontroller,

      children: [
        //LoginView(action: action, providers: providers),
        Scaffold(
          body: Center(
            child: Container(
             
              width: MediaQuery.of(context).size.width-100,
             // height: MediaQuery.of(context).size.height-200,
              decoration:const BoxDecoration(),
              child: Card(
                
                child: SingleChildScrollView(
                  child: Padding(
                     padding:const EdgeInsets.only(top:100,bottom: 100,left: 10,right: 10 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       const Padding(
                          padding:  EdgeInsets.all(8.0),
                          child: Text("Sign In",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 30),),
                        ),
                       const Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text("email"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: loginEmail,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:const BorderSide(color: Colors.black)
                              )
                            ),
                          ),
                        ),
                       const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("password"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: loginPassword,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:const BorderSide(color: Colors.black)
                                )
                              ),
                          ),
                    
                        ),
                        const SizedBox(height: 20,),
                        TextButton(onPressed: ()async{
                         String state = await AuthMethods().signIn(email: loginEmail.text, password: loginPassword.text);
                         if (state == "Success") {
                           Navigator.pop(context);
                         }
                        }, child: const Padding(padding: EdgeInsets.all(10),child: Text("Sign In"),)),
                       const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Or Log in with",style: TextStyle(fontSize: 12),),
                        ),
                        Center(
                          child: Card(
                            child: SizedBox(
                              height: 50,
                              width: 200,
                              child: InkWell(
                                onTap: (){},
                                
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                         const Padding(
                            padding: EdgeInsets.all(8.0),
                            child:Text("Don't have an account"),
                          ),
                            TextButton(onPressed: ()async{
                            // print(pagecontroller.page);
                              pagecontroller.animateToPage(1, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
                            }, child:const Text("Sign Up",textAlign: TextAlign.left,))
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          body: Center(
            child: Card(
              margin:const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const Padding(
                    padding:  EdgeInsets.only(left: 25.0),
                    child: Text("Sign Up",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 28),),
                  ),
                 const Padding(
                    padding:  EdgeInsets.all(5.0),
                    child:  Text("Full Name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:const BorderSide(color: Colors.black)
                        )
                      ),
                    ),
                  ),
                 const Padding(
                    padding:  EdgeInsets.all(5.0),
                    child:  Text("Email"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: signupEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:const BorderSide(color: Colors.black)
                        )
                      ),
                    ),
                  ),
                const  Padding(
                    padding:  EdgeInsets.all(5.0),
                    child:  Text("Password"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: signUpPassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:const BorderSide(color: Colors.black)
                        )
                      ),
                    ),
                  ),
                 const Padding(
                    padding: EdgeInsets.all(5.0),
                    child:  Text("Confirm Password"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: signUpPasswordconfirm,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:const BorderSide(color: Colors.black)
                        )
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: ()async{
                    String state =await AuthMethods().createAccount(email: signupEmail.text,password: signUpPassword.text,fullName: name.text);
                    if (state == "Success") {
                      await AuthMethods().signIn(email: signupEmail.text, password: signUpPassword.text);
                      Navigator.pop(context);
                    }
                  }, 
                  child:const Center(
                    child: Card(
                     // color: const Color.fromARGB(255, 82, 78, 214),
                      child: Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Text("Sign Up",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                      ),),
                  )
                    ),
                  const Text("Or log in using..."),
                  Card(
                    margin:const EdgeInsets.all(20),
                    child: InkWell(
                      child: Container(
                        height: 50,
                       // width:300,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                     const Padding(
                        padding:  EdgeInsets.all(5.0),
                        child:  Text("Already have an account"),
                      ),
                      TextButton(onPressed: (){
                        pagecontroller.animateToPage(0, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
                      }, child: const Text("sign in"))
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}