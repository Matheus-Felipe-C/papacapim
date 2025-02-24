import 'package:flutter/material.dart';

class Feed extends StatelessWidget {

  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feed")),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: List.generate(20, (index) => Container(
          height: 100,
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.blueGrey[100],
        )),
      ),
    );   
  }
}