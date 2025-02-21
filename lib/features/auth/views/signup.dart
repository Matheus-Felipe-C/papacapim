import 'package:flutter/material.dart';
import 'package:papacapim/styles.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign-up")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Inscreva-se", style: AppStyles.heading),
              const SizedBox(height: 20),
              TextField(decoration: AppStyles.textFieldDecoration("Nome")),
              const SizedBox(height: 10),
              TextField(decoration: AppStyles.textFieldDecoration("Email")),
              const SizedBox(height: 10),
              TextField(
                decoration: AppStyles.textFieldDecoration("Senha"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: AppStyles.elevatedButton,
                child: const Text("Inscrever-se"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
