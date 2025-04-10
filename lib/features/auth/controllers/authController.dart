import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier{
  List<User> users = [];
  static const _userKey = 'user_data';

  /// Cria um novo usuário e sessão a partir da API
  Future<bool> createUser(String name, String username, String password, String passwordConfirm) async {
    try {
      User newUser = await ApiService().createUser(username, name, password, passwordConfirm);
      Session newSession = await ApiService().createSession(username, password);
      await saveSessionToPrefs(newSession);
      return true;
    } catch (e) {
      print("Erro ao criar usuário: $e");
      return false;
    }
  }

  /// Salva a sessão
  Future<void> saveSessionToPrefs(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(session.toJson());
    await prefs.setString(_userKey, userJson);
  }
}
  