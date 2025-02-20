import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/login.dart';

void main() {
  runApp(const MainApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // 👈 Ensures Navigator is always accessible
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
                navigatorKey.currentState?.push(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
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
