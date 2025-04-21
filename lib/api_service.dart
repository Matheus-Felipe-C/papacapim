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

  Future<User> updateUser(String userID,
      {String? login,
      String? name,
      String? password,
      String? passwordConfirmation}) async {
    final session =
        ""; //Sessão só pra evitar erros no código em si, tenho que mudar dps

    final Map<String, dynamic> body = {};

    if (login != null) body['login'] = login;
    if (name != null) body['name'] = name;
    if (password != null) body['password'] = password;
    if (passwordConfirmation != null)
      body['password_confirmation'] = passwordConfirmation;

    final response = await http.patch(Uri.parse("$baseUrl/users/$userID"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $session",
        },
        body: jsonEncode(body));

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Algo deu errado ao realizar as alterações");
    }
  }
}
