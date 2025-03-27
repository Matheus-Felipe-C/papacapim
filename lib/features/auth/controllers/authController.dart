import 'package:flutter/material.dart';
import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/auth/models/user.dart';

class AuthController extends ChangeNotifier{
  final ApiService _apiService = ApiService();
  List<User> users = [];

  Future<void> createUser(String name, String username) async {
    try {
      User newUser = await _apiService.createUser(name, username);
      users.add(newUser);
      notifyListeners();
      print(newUser);
    } catch (e) {
      print("Erro ao criar usuário: $e");
    }
  }
}