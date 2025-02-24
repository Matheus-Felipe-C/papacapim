import 'package:flutter/material.dart';
import 'package:papacapim/styles.dart';

class PostCard extends StatelessWidget {
  final String message;
  final String username;

  const PostCard({super.key, required this.message, required this.username});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("@$username",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
            Text(
              message,
              style: AppStyles.bodyText,
            )
          ],
        ),
      ),
    );
  }
}
