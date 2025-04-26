import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/styles.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _signup() async {
    String name = _nameController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    final auth = context.read<AuthController>();

    if (name.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    try {
      await auth.createUser(name, username, password, confirmPassword);
      Navigator.pushNamedAndRemoveUntil(
          context,
          '/feed',
          (route) =>
              false); // Redireciona para o feed e remove todos os itens da stack
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
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
              TextField(
                  controller: _nameController,
                  decoration: AppStyles.textFieldDecoration("Nome")),
              const SizedBox(height: 10),
              TextField(
                  controller: _usernameController,
                  decoration: AppStyles.textFieldDecoration("Username")),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: AppStyles.textFieldDecoration("Senha"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextField(
                  controller: _confirmPasswordController,
                  decoration: AppStyles.textFieldDecoration("Confirme a senha"),
                  obscureText: true),
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
