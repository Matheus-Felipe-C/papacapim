import 'dart:convert';

import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "api.papacapim.just.pro.br";

  // Cria um usuário
  Future<User> createUser(String login, String name, String password,
      String passwordConfirm) async {
    final response = await http.post(Uri.https(baseUrl, "/users"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user": {
            "login": login,
            "name": name,
            "password": password,
            "password_confirmation": passwordConfirm
          }
        }));

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Usuário: ${data['login']}');
      return User.fromJson(data);
    } else {
      throw Exception("Falha ao criar usuário");
    }
  }

  /// Cria uma nova sessão a partir da API
  Future<Session> createSession(String login, String password) async {
    final response = await http.post(Uri.https(baseUrl, "/sessions"),
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
  Future<void> deleteSession(String id, String token) async {
    final response = await http.delete(
      Uri.https(baseUrl, "/sessions/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 204) {
      print("Sessão encerrada com sucesso");
    } else {
      throw Exception("Erro ao encerrar a sessão: ${response.statusCode}");
    }
  }

  Future<User> updateUser(String token, String userID,
      {String? login,
      String? name,
      String? password,
      String? passwordConfirmation}) async {

    final Map<String, dynamic> body = {};

    final hasPassword = password != null && password.isNotEmpty;
    final hasConfirmation = passwordConfirmation != null && passwordConfirmation.isNotEmpty;

    if (login != null) body['login'] = login;
    if (name != null) body['name'] = name;

    if (hasPassword || hasConfirmation) {
      if (password != passwordConfirmation) {
        throw Exception("As senhas não coincidem");
      }

      body['password'] = password;
      body['password_confirmation'] = passwordConfirmation;
    }

    final response = await http.patch(Uri.https(baseUrl, "/users"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 204) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Algo deu errado ao realizar as alterações");
    }
  }
}
