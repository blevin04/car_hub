
import 'package:car_hub/firebasemethods.dart';
import 'package:car_hub/utils.dart';
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
int currentScreen = 0;
class _AuthpageState extends State<Authpage> {
  @override
  void initState() {
    // TODO: implement initState
loginEmail = TextEditingController();
loginPassword = TextEditingController();
name = TextEditingController();
signupEmail = TextEditingController();
signUpPassword = TextEditingController();
signUpPasswordconfirm = TextEditingController();
    super.initState();
  }
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
  bool passwordMatch = true;
  bool hidePassword = true;
  bool hideConfirmPassword = true;
Widget screen0(){
  switch (currentScreen) {
    case 1:
      return Container(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                    changeScreen(0);
                  }, icon:const Icon(Icons.keyboard_arrow_left,size: 30,)),
                  const Text("Sign Up",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                ],
              ),
              const SizedBox(height: 50,),
              Padding(
                padding:const EdgeInsets.all(20),
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:const BorderSide(color: Colors.black,width: 3)
                    )
                  ),
                ),
              ),
              Padding(
                padding:const EdgeInsets.all(20),
                child: TextField(
                  controller: signupEmail,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:const BorderSide(color: Colors.black,width: 3)
                    )
                  ),
                ),
              ),
              Padding(
                padding:const EdgeInsets.all(20),
                child: TextField(
                  obscureText: hidePassword,
                  controller: signUpPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    }, icon: Icon( hidePassword? Icons.visibility:Icons.visibility_off)),
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:const BorderSide(color: Colors.black,width: 3)
                    )
                  ),
                ),
              ),
              Padding(
                padding:const EdgeInsets.all(20),
                child: TextField(
                  onChanged: (value){
                    if (value != signUpPassword.text) {
                      setState(() {
                        passwordMatch = false;
                      });
                    }else{
                      setState(() {
                        passwordMatch = true;
                      });
                    }
                  },
                  controller: signUpPasswordconfirm,
                  obscureText: hideConfirmPassword,
                  decoration: InputDecoration(
                    
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        hideConfirmPassword = !hideConfirmPassword;
                      });
                    }, icon: Icon(
                      hideConfirmPassword? Icons.visibility:
                      Icons.visibility_off,
                      color: passwordMatch?null:Colors.red,
                      )),
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(
                      color: passwordMatch?null:Colors.red
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color:passwordMatch? Colors.black:Colors.red,width: 3)
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color:passwordMatch? Colors.black:Colors.red,width: 3)
                    )
                  ),
                ),
              ),
              InkWell(
                onTap: ()async{
                  if (name.text.isEmpty) {
                    showsnackbar(context, "Enter name");
                  }
                  if (signupEmail.text.isEmpty||!signupEmail.text.contains("@")) {
                    showsnackbar(context, "Enter valid email");
                  }
                  if (signUpPassword.text.isEmpty) {
                    showsnackbar(context, "enter password");
                  }
                  if(
                    signUpPassword.text.isNotEmpty&&
                    signupEmail.text.isNotEmpty &&
                    name.text.isNotEmpty
                  ){
                    String state ="";
                  while (state.isEmpty) {
                    showDialog(context: context, builder: (context){
                      return const Dialog(
                        backgroundColor: Colors.transparent,
                        child:  Center(child: CircularProgressIndicator()),
                      );
                    });
                    state = await AuthMethods().createAccount(
                      email: signupEmail.text, password: signUpPassword.text, fullName: name.text);
                  }
                  Navigator.pop(context);
                  if (state == "email-already-in-use") {
                    showsnackbar(context, "Email Already in use, please login");
                  }
                  if (state == "invalid-email") {
                    showsnackbar(context, "Please use a valid email");
                  }
                  if (state == "network-request-failed") {
                    showsnackbar(context, "Failed check connection");
                  }
                  if (state == "weak-password") {
                    showsnackbar(context, "password is weak");
                  }
                  if (state == "Success") {
                    showsnackbar(context, "Welcome ${name.text}");
                    Navigator.pop(context);
                  }else{
                    showsnackbar(context, state);
                  }
                  }
                  
                },
                
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 50,
                  width: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child:const Text("Sign Up",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
              const SizedBox(height: 50,)
            ],
          ),
        );
      
    case 0:
     return Container(
                //width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   const SizedBox(height: 50,),
                   const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Welcome",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.blue),),
                      
                    ),
                    const SizedBox(height: 40,),
                    const Text("Suck squeeze bang blow"),
                    const SizedBox(height: 30,),
                    InkWell(
                      onTap: (){
                        changeScreen(1);
                      },
                      borderRadius: BorderRadius.circular(15),
                      child:Container(
                        width: 150,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black
                        ),
                        child: const Text("Sign in",style: TextStyle(color: Colors.white),),
                      )
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: (){
                        changeScreen(2);
                      },
                      child: Container(
                        width: 150,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black,width: 3),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child:const Text("Sign in",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      ),
                    ),
                    const SizedBox(height: 50,)
                  ],
                ),
              );
    case 2:
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: (){
                  changeScreen(0);
                }, icon: const Icon(Icons.keyboard_arrow_left_outlined,size: 28,)),
               const Text("Sign In",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
              ],
            ),
            const SizedBox(height: 20,),
            Padding(
                padding:const EdgeInsets.all(20),
                child: TextField(
                  //controller: name,
                  controller: loginEmail,
                  decoration: InputDecoration(
                    labelText: "email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:const BorderSide(color: Colors.black,width: 3)
                    )
                  ),
                ),
              ),
              Padding(
                padding:const EdgeInsets.all(20),
                child: TextField(
                  //controller: name,
                  controller: loginPassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:const BorderSide(color: Colors.black,width: 3)
                    )
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: ()async{
                  if (loginEmail.text.isNotEmpty && loginPassword.text.isNotEmpty) {
                    String state = "";
                    while (state.isEmpty) {
                      showDialog(context: context, builder: (context){
                        return const Dialog(
                          backgroundColor: Colors.transparent,
                          child: Center(child: CircularProgressIndicator(),),
                        );
                      });
                      state = await AuthMethods().signIn(email: loginEmail.text, password: loginPassword.text);
                    }
                    Navigator.pop(context);
                    if (state == "wrong-password") {
                      showsnackbar(context, "Wrong password, try again");
                    }
                    if (state == "user-not-found") {
                      showsnackbar(context, "User not found, create account");
                    }
                    if (state == "invalid-email") {
                      showsnackbar(context, "Please use a valid email");
                    }
                    if (state == "network-request-failed") {
                      showsnackbar(context, "Failed check connection");
                    }
                    if (state == "user-disabled") {
                      showsnackbar(context, "Well shit happens, create another account");
                    }
                    if (state == "Success") {
                      showsnackbar(context, "Welcome back");
                      Navigator.pop(context);
                    }
                    if (state == "user-disabled") {
                      showsnackbar(context, "Account disabled");
                    }
                    if (state == "user-not-found") {
                      showsnackbar(context, "Account not found try to create an account first");
                    }
                    if (state == "wrong-password") {
                      showsnackbar(context, "Wrong password"); 
                    }
                  }
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 50,
                  width: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child:const Text("Sign in",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
              
              const SizedBox(height: 30,)
          ],
        ),
      );
      
    default:
  }
  return Container();
}
void changeScreen (int screennum){
  setState(() {
    currentScreen = screennum;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 228, 226, 221),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Container(
              child:const Image(image: AssetImage("lib/assets/CAR_HUB.png")),
            ),
            Card(
              color: Colors.white,
              elevation: 10,
              margin:const EdgeInsets.all(0),
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: screen0(),
              )
            )
          ],
        ),
      ),
    );
  }
}

// PageView(
//       controller: pagecontroller,

//       children: [
//         //LoginView(action: action, providers: providers),
//         Scaffold(
//           body: Center(
//             child: Container(
             
//               width: MediaQuery.of(context).size.width-100,
//              // height: MediaQuery.of(context).size.height-200,
//               decoration:const BoxDecoration(),
//               child: Card(
                
//                 child: SingleChildScrollView(
//                   child: Padding(
//                      padding:const EdgeInsets.only(top:100,bottom: 100,left: 10,right: 10 ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                        const Padding(
//                           padding:  EdgeInsets.all(8.0),
//                           child: Text("Sign In",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 30),),
//                         ),
//                        const Padding(
//                           padding: EdgeInsets.only(left: 5.0),
//                           child: Text("email"),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             controller: loginEmail,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide:const BorderSide(color: Colors.black)
//                               )
//                             ),
//                           ),
//                         ),
//                        const Padding(
//                           padding: EdgeInsets.all(5.0),
//                           child: Text("password"),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             controller: loginPassword,
//                             decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide:const BorderSide(color: Colors.black)
//                                 )
//                               ),
//                           ),
                    
//                         ),
//                         const SizedBox(height: 20,),
//                         TextButton(onPressed: ()async{
//                          String state = await AuthMethods().signIn(email: loginEmail.text, password: loginPassword.text);
//                          if (state == "Success") {
//                            Navigator.pop(context);
//                          }
//                         }, child: const Padding(padding: EdgeInsets.all(10),child: Text("Sign In"),)),
//                        const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text("Or Log in with",style: TextStyle(fontSize: 12),),
//                         ),
//                         Center(
//                           child: Card(
//                             child: SizedBox(
//                               height: 50,
//                               width: 200,
//                               child: InkWell(
//                                 onTap: (){},
                                
//                               ),
//                             ),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                          const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child:Text("Don't have an account"),
//                           ),
//                             TextButton(onPressed: ()async{
//                             // print(pagecontroller.page);
//                               pagecontroller.animateToPage(1, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
//                             }, child:const Text("Sign Up",textAlign: TextAlign.left,))
//                           ],
//                         ),
                        
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Scaffold(
//           body: Center(
//             child: Card(
//               margin:const EdgeInsets.all(40),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                  const Padding(
//                     padding:  EdgeInsets.only(left: 25.0),
//                     child: Text("Sign Up",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 28),),
//                   ),
//                  const Padding(
//                     padding:  EdgeInsets.all(5.0),
//                     child:  Text("Full Name"),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: name,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide:const BorderSide(color: Colors.black)
//                         )
//                       ),
//                     ),
//                   ),
//                  const Padding(
//                     padding:  EdgeInsets.all(5.0),
//                     child:  Text("Email"),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: signupEmail,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide:const BorderSide(color: Colors.black)
//                         )
//                       ),
//                     ),
//                   ),
//                 const  Padding(
//                     padding:  EdgeInsets.all(5.0),
//                     child:  Text("Password"),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: signUpPassword,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide:const BorderSide(color: Colors.black)
//                         )
//                       ),
//                     ),
//                   ),
//                  const Padding(
//                     padding: EdgeInsets.all(5.0),
//                     child:  Text("Confirm Password"),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: signUpPasswordconfirm,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide:const BorderSide(color: Colors.black)
//                         )
//                       ),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: ()async{
//                     String state =await AuthMethods().createAccount(email: signupEmail.text,password: signUpPassword.text,fullName: name.text);
//                     if (state == "Success") {
//                       await AuthMethods().signIn(email: signupEmail.text, password: signUpPassword.text);
//                       Navigator.pop(context);
//                     }
//                   }, 
//                   child:const Center(
//                     child: Card(
//                      // color: const Color.fromARGB(255, 82, 78, 214),
//                       child: Padding(
//                         padding:  EdgeInsets.all(8.0),
//                         child: Text("Sign Up",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
//                       ),),
//                   )
//                     ),
//                   const Text("Or log in using..."),
//                   Card(
//                     margin:const EdgeInsets.all(20),
//                     child: InkWell(
//                       child: Container(
//                         height: 50,
//                        // width:300,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                      const Padding(
//                         padding:  EdgeInsets.all(5.0),
//                         child:  Text("Already have an account"),
//                       ),
//                       TextButton(onPressed: (){
//                         pagecontroller.animateToPage(0, duration:const Duration(milliseconds: 250), curve: Curves.bounceInOut);
//                       }, child: const Text("sign in"))
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         )
//       ],
//     );