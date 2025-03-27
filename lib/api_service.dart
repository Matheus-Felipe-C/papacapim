import 'dart:convert';

import 'package:papacapim/features/auth/models/user.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.papacapim.just.pro.br";

  // Cria um usuário
  Future<User> createUser(String name, String username) async{
    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "login": username})
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Falha ao criar usuário");
    }
  }
}