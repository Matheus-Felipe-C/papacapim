import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/profile_controller.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:papacapim/features/feed/controllers/feedController.dart';
import 'package:papacapim/features/feed/views/PostDetailScreen.dart';
import 'package:papacapim/features/feed/views/postCard.dart';
import 'package:papacapim/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController();
    feedController;
    final User user = User(id: 1, name: 'test', username: 'testprofile');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/edit_profile'),
            child: const Text("Editar perfil"),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: AppStyles.heading),
            Text(user.username),
            Expanded(
              child: ListView.builder(
                itemCount: feedController.posts.length,
                itemBuilder: (context, index) {
                  final post = feedController.posts[index];
                  return PostCard(
                    message: post.message,
                    username: user.username,
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
            ),
          ],
        ),
      ),
    );
  }
}
