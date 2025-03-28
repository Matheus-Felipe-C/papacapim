import 'dart:convert';

import 'package:papacapim/features/auth/models/user.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.papacapim.just.pro.br";

  // Cria um usuário
  Future<User> createUser(String login, String name, String password, String passwordConfirm) async{
    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "login": login, "password": password, "password_confirmation": passwordConfirm})
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Falha ao criar usuário");
    }
  }
}