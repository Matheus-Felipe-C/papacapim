import 'package:flutter/material.dart';
import 'package:papacapim/features/feed/views/post.dart';

class Feed extends StatelessWidget {

  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> posts = [
      {"content": "This is the first post"},
      {"content": "This is the second post"},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Feed")),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Post(
            content: posts[index]["content"]!,
          );
        },
      ),
    );   
  }
}