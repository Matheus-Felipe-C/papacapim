import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:provider/provider.dart';
import '../../../styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    final auth = context.read<AuthController>();

    try {
      await auth.login(username, password);
      Navigator.pushNamedAndRemoveUntil(context, '/feed', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min,
            children: [
              const Text("Faça login", style: AppStyles.heading),
              const SizedBox(height: 20),
              TextField(
                  controller: _usernameController,
                  decoration: AppStyles.textFieldDecoration("Email")),
              const SizedBox(height: 10),
              TextField(
                  controller: _passwordController,
                  decoration: AppStyles.textFieldDecoration("Senha"),
                  obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _login();
                },
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
