import 'package:flutter/material.dart';
import 'package:papacapim/styles.dart';

class PostCard extends StatelessWidget {
  final String message;
  final String username;
  final int likes;
  final bool isLikedByCurrentUser;
  final VoidCallback onLikePressed;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.message,
    required this.username,
    required this.likes,
    required this.isLikedByCurrentUser,
    required this.onLikePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Navega para a tela de detalhes ao clicar no post
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome do usuário
              Text(
                username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),

              // Mensagem do post
              Text(message),
              const SizedBox(height: 8),

              // Botão de curtir e número de curtidas
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLikedByCurrentUser ? Icons.favorite : Icons.favorite_border,
                      color: isLikedByCurrentUser ? Colors.red : null,
                    ),
                    onPressed: onLikePressed,
                  ),
                  Text('$likes curtidas'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
