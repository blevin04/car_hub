import 'package:car_hub/backendFxns.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
showsnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

String duration(DateTime time){
  String timeS = "";
  print(DateTime.now().difference(time).inMinutes);
  print(DateTime.now());
  if (DateTime.now().difference(time).inDays>0) {
    timeS = DateTime.now().difference(time).inDays.toString();
    timeS+=" days ago";
  }
  if(DateTime.now().difference(time).inHours>0&&DateTime.now().difference(time).inDays<=0){
  
    timeS = DateTime.now().difference(time).inHours.toString();
    timeS+=" hrs ago";
  }
   if(DateTime.now().difference(time).inMinutes>1&&DateTime.now().difference(time).inHours<=0){
    
    timeS = DateTime.now().difference(time).inMinutes.toString();
    timeS +=" min ago";
  }
  if(DateTime.now().difference(time).inSeconds>1&& DateTime.now().difference(time).inMinutes<=0){
    
    timeS = DateTime.now().difference(time).inSeconds.toString();
    timeS+=" sec ago";
  }
  
  return timeS;
}
Future<String> getUserName(String userId)async{
  String nameU = "";
  await firestore.collection("users").doc(userId).get().then((onValue){
    nameU = onValue.data()!["fullName"];
  });
  return nameU;
}

Future<String> getContent(BuildContext context,FileType filetype)async{
  String image = "";
  Permission.accessMediaLocation
    .onDeniedCallback(() async {
  Permission.accessMediaLocation.request();
  if (await Permission.accessMediaLocation.isDenied) {
    showsnackbar(context, "Permission denied");
  }
  if (await Permission.accessMediaLocation.isGranted) {
    showsnackbar(context, 'Granted');
  }
});

FilePickerResult? result = (await FilePicker.platform
    .pickFiles(type: filetype,allowMultiple: false));
if (result != null) {
  image = result.files.single.path!;
 // setState(() {});
}
if (result == null) {
  showsnackbar(context, 'no file chossen');
}
return image;
}

void showcircularProgressIndicator(BuildContext context)async{
  return await showDialog(context: context, builder: (context){
                return const Dialog(
                  backgroundColor: Colors.transparent,
                  child: Center(child: CircularProgressIndicator(),),
                );
              });
}