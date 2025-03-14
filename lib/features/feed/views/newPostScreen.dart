import 'package:flutter/material.dart';
import 'package:papacapim/styles.dart';

class NewPostScreen extends StatefulWidget {
    const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
    final TextEditingController _contentController = TextEditingController();
    
    void _submitPost(BuildContext context){
        if (_contentController.text.isEmpty) return;

        Navigator.pop(context, {"message": _contentController.text});
    }

    @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("New post"),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => _submitPost(context),
          child: const Text("Postar"),
          )
      ],
      ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _contentController,
            decoration: AppStyles.textFieldDecoration("Escreva sua mensagem aqui"),
            maxLines: 4,
          ),
        ],
      ),
    ),
  );
  }
}