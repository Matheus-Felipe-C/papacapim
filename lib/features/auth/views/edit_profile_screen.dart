import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:papacapim/styles.dart';
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
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final auth = context.read<AuthController>();
    final profile = context.read<ProfileController>();

    if (auth.session == null && !auth.isLoadingSession) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro: Sessão não encontrada")),
      );
    } else if (profile.user == null && !profile.isLoading) {
      await profile.getUser();
    }
  });
}

  Future<void> _saveChanges({String? login, String? name, String? password, String? confirmPassword}) async {
    final auth = context.read<AuthController>();

    try {
      await auth.updateUser(login, name, password, confirmPassword);
      print("Usuário atualizado!");
      Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text("Salvar"),
          ),
        ],  
      ),
      body: Consumer<ProfileController>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 20,),
                  ElevatedButton(onPressed: provider.getUser, child: const Text('Tente novamente'),
                  ),
                ],
              ),
            );
          }

          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16,),
                  Text("Carregando perfil..."),
                ],
              ),
            );
          }

          if (provider.user == null) {
            return const Center(child: Text("Não foi possível pegar dados de perfil"),);
          }

          final profile = provider.user!;
          _nameController.text = profile.name;
          _usernameController.text = profile.username;
          _passwordController.text = '';
          _confirmPasswordController.text = ''; 
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Editar perfil", style: AppStyles.heading,),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: AppStyles.textFieldDecoration("Nome"),
                ),
                TextField(
                  controller: _usernameController,
                  decoration: AppStyles.textFieldDecoration("Nome de usuário"),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: AppStyles.textFieldDecoration("Senha"),
                  obscureText: true,
                ),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: AppStyles.textFieldDecoration("Confirme a senha"),
                  obscureText: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
