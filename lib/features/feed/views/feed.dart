import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:papacapim/features/feed/controllers/feedController.dart';
import 'package:papacapim/features/feed/views/newPostScreen.dart';
import 'package:papacapim/features/feed/views/postCard.dart';
import 'package:papacapim/features/feed/views/postDetailScreen.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final FeedController feedController = FeedController();
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ),
      body: ListView.builder(
        itemCount: feedController.posts.length,
        itemBuilder: (context, index) {
          final post = feedController.posts[index];
          return PostCard(
            message: post.message,
            username: post.user.username,
            likes: post.likes,
            isLikedByCurrentUser: post.isLikedByCurrentUser,
            onLikePressed: () {
              setState(() {
                feedController.toggleLike(post);
              });
            },
            onTap: () {
              // Navega para a tela de detalhes do post
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(
                    post: post,
                    feedController: feedController,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPost = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPostScreen()),
          );

          if (newPost != null && authController.currentUser != null) {
            setState(() {
              feedController.addPost(
                  newPost["message"], authController.currentUser!);
            });
          } else if (authController.currentUser == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      "Você precisa estar autenticado para criar um novo post.")),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
