import 'package:flutter/material.dart';
import 'package:papacapim/styles.dart';

class Post extends StatelessWidget {
  final String content;

  const Post({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: AppStyles.bodyText,
            )
          ],
        ),
      ),
    );
  }
}
