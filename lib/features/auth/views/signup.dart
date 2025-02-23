import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/styles.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _signup() {
    String name = _nameController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    bool success = AuthController().createUser(name, username, password, confirmPassword);

    if (success) {
      print("User registered!");
      Navigator.pop(context); // Return to login
    } else {
      print("Passwords do not match!");
    }
  }
  
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
              TextField(controller: _nameController, decoration: AppStyles.textFieldDecoration("Nome")),
              const SizedBox(height: 10),
              TextField(controller: _usernameController, decoration: AppStyles.textFieldDecoration("Username")),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: AppStyles.textFieldDecoration("Senha"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextField(controller: _confirmPasswordController, decoration: AppStyles.textFieldDecoration("Confirme a senha")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _signup();
                },
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
