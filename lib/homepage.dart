import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 20,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 40,
              ),
              title: Text("Hello User Name ",style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text("Lets Rev up"),
            )
          ],
        ),
      ),
    );
  }
}