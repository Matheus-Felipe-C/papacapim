import 'dart:convert';

import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.papacapim.just.pro.br";

  // Cria um usuário
  Future<User> createUser(String login, String name, String password,
      String passwordConfirm) async {
    final response = await http.post(Uri.parse("$baseUrl/users"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "login": login,
          "password": password,
          "password_confirmation": passwordConfirm
        }));

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Falha ao criar usuário");
    }
  }

  /// Cria uma nova sessão a partir da API
  Future<Session> createSession(String login, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/sessions"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"login": login, "password": password}));

    if (response.statusCode == 200) {
      return Session.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Algo deu errado ao criar uma nova sessão");
    }
  }

  /// Apaga uma sessão existente
  /// P.S - Preciso pesquisar
  Future<void> deleteSession() async {
    final response = await http.delete(
      Uri.parse("$baseUrl/sessions/1"),
    );
  }

}
