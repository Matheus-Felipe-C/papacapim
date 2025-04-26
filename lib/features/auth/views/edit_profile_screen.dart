import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Future<void> initState() async {
    super.initState();
    final profile = context.watch<ProfileController>();
    final auth = context.watch<AuthController>();
    final user = await profile.getUser(auth.session!.token);

    // Initialize text fields with current user data
    _nameController.text = user.name;
    _usernameController.text = user.username;
  }

  void _saveChanges(String? login, String? name, String? password,
      String? passConfirm) async {
    final auth = context.read<AuthController>();
    final profile = context.read<ProfileController>();

    final user = await profile.getUser(auth.session!.token);
    await auth.updateUser(user.id, login, name, password, passConfirm);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil atualizado!")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Usuário"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Senha"),
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration:
                  const InputDecoration(labelText: "Confirmação de senha"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveChanges(
                  _usernameController.text,
                  _nameController.text,
                  _passwordController.text,
                  _confirmPasswordController.text,
                );
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
