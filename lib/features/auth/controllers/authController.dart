import 'package:flutter/material.dart';
import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/auth/models/user.dart';

class AuthController extends ChangeNotifier{
  final ApiService _apiService = ApiService();
  List<User> users = [];

  Future<bool> createUser(String name, String username, String password, String passwordConfirm) async {
    try {
      User newUser = await _apiService.createUser(username, name, password, passwordConfirm);
      users.add(newUser);
      notifyListeners();
      print(newUser);
      return true;
    } catch (e) {
      print("Erro ao criar usuário: $e");
      return false;
    }
  }
}