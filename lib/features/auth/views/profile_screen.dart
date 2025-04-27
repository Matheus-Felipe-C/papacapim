import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Consumer<ProfileController>(
        builder: (context, provider, child) {
          //Mostra mensagem de erro se existir
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: provider.getUser,
                    child: const Text('Tente novamente'),
                  ),
                ],
              ),
            );
          }

          //Mostra tela de loading enquanto espera dados da API
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Carregando perfil..."),
                ],
              ),
            );
          }

          //Mensagem de erro genérica se por algum motivo o usuário não for carregado
          if (provider.user == null) {
            return const Center(
              child: Text("Não foi possível pegar dados de perfil"),
            );
          }

          //Mostra o perfil do usuário
          final profile = provider.user!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${profile.name}"),
                const SizedBox(
                  height: 8,
                ),
                Text("Username: ${profile.username}"),
                ElevatedButton(
                  onPressed: () => {
                    Navigator.pushNamed(context, '/edit_profile'),
                  },
                  child: const Text("Editar perfil"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
