import 'package:papacapim/features/auth/models/user.dart';

class AuthController {
  // Esses atributos transformam o AuthController em um Singleton, que pode ser utilizado por todo o app
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;
  AuthController._internal();
  
  User? currentUser;

  /// Cria um usuário
  bool createUser(String name, String username, String password, String confirmPassword) {
    if (password != confirmPassword) {
      return false;
    }

    currentUser = User(name: name, username: username, password: password);
    return true;
  }

  /// Verifica se as credenciais estão corretas
  bool validateCredentials(String username, String password) {
    if (currentUser != null && 
    currentUser!.username == username &&
    currentUser!.password == password) {
      return true;
    }

    return false;
  }
  
  /// Desloga o usuário
  void logout() {
    currentUser = null;
  }
}

// Cria uma instância global do AuthController
final authController = AuthController();