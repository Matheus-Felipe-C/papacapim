import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Boas vindas"),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => LoginPage() 
                  ) 
                );
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Increver-se'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
