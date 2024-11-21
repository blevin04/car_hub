import 'package:car_hub/backendFxns.dart';
import 'package:flutter/material.dart';

class Chatrooms extends StatefulWidget {
  const Chatrooms({ Key? key }) : super(key: key);

  @override
  _ChatroomsState createState() => _ChatroomsState();
}

class _ChatroomsState extends State<Chatrooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getrooms(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return ;
            },
          );
        },
      ),
    );
  }
}