import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/features/auth/models/user.dart';
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
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileController>();
    final auth = context.read<AuthController>();

    _userFuture = profile.getUser(auth.session!.userLogin);
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
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"),);
          } else if (snapshot.hasData) {
            final user = snapshot.data!;

            _nameController.text = user.name;
            _usernameController.text = user.username;
            _passwordController.text = '';
            _confirmPasswordController.text = '';

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Nome"),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: "Nome"),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: "Nome"),
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: "Nome"),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Nenhum dado encontrado"),);
          }
        },
      ),
    );
  }
}
