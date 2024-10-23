
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Profile",style: TextStyle(fontWeight: FontWeight.bold,),),
        actions: [
          IconButton(onPressed: (){}, icon:const Icon(Icons.sunny))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 52,
                child: Icon(Icons.person),
              ),
              title: Text("Users Name",style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text("Edit profile"),
              trailing: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      ),
    );
  }
}