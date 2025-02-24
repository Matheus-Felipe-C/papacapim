import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/features/feed/controllers/feedController.dart';
import 'package:papacapim/features/feed/views/newPostScreen.dart';
import 'package:papacapim/features/feed/views/postCard.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feed")),
      body: ListView.builder(
        itemCount: feedController.posts.length,
        itemBuilder: (context, index) {
          final post = feedController.posts[index];
          return PostCard(
            message: post.message,
            username: post.user.username,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPost = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPostScreen()),
          );

          print("Novo post recebido: $newPost");

          if (newPost != null && authController.currentUser != null) {
            setState(() {
              feedController.addPost(
                  newPost["message"], authController.currentUser!);
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("You must be logged in to create a post.")),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
