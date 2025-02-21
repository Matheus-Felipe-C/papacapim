import 'package:flutter/material.dart';
import '../../../styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        // ⬅️ This centers the Column on the screen
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // ⬅️ Ensures the column only takes the necessary space
            children: [
              const Text("Faça login", style: AppStyles.heading),
              const SizedBox(height: 20),
              TextField(decoration: AppStyles.textFieldDecoration("Email")),
              const SizedBox(height: 10),
              TextField(
                  decoration: AppStyles.textFieldDecoration("Senha"),
                  obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: AppStyles.elevatedButton,
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
