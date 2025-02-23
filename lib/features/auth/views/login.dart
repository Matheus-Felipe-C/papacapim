import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import '../../../styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _usernameController.text;

    bool isValid = AuthController().validateCredentials(username, password);

    if (isValid) {
      print("Login feito com sucesso!");
      Navigator.pushReplacementNamed(context, '/home'); // Volta pra home page
    } else {
      print('Credenciais inválidas');
    }
  }

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
              TextField(controller: _usernameController, decoration: AppStyles.textFieldDecoration("Email")),
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
