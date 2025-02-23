import 'package:papacapim/features/auth/models/user.dart';

class Authcontroller {
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