import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/features/feed/controllers/feedController.dart';
import 'package:papacapim/styles.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
    const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
    final TextEditingController _contentController = TextEditingController();
    
    Future<void> _submitPost(BuildContext context) async {
        if (_contentController.text.isEmpty) return;

        final feed = context.read<FeedController>();
        final auth = context.read<AuthController>();

        await feed.addPost(_contentController.text, auth.token!);

        Navigator.pop(context, true);
    }

    @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("New post")),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _contentController,
            decoration: AppStyles.textFieldDecoration("Escreva sua mensagem aqui"),
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _submitPost(context),
            child: const Text("Postar"),
          ),
        ],
      ),
    ),
  );
  }
}