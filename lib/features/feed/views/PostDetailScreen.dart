import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:papacapim/features/feed/models/post.dart';
import 'package:papacapim/features/feed/controllers/feedController.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  final FeedController feedController;
  final user = User(id: '1', name: 'test', username: 'test');

  PostDetailScreen({
    super.key,
    required this.post,
    required this.feedController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do usuário
            Text(
              user.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),

            // Mensagem do post
            Text(
              post.message,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Botão de curtir e número de curtidas
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.isLikedByCurrentUser ? Icons.favorite : Icons.favorite_border,
                    color: post.isLikedByCurrentUser ? Colors.red : null,
                  ),
                  onPressed: () {
                    feedController.toggleLike(post);
                  },
                ),
                Text('${post.likes} curtidas'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
