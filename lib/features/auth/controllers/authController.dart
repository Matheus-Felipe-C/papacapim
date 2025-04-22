import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  Session? _session;
  String? _userPass;

  Session? get session => _session;
  String? get token => _session?.token;
  String? get userPass => _userPass;

  // Cria um novo usuário
  Future<void> login(String login, String password) async {
    final session = await ApiService().createSession(login, password);
    await saveSessionToPrefs(session);
    _userPass = password;
  }

  /// Cria um novo usuário e sessão a partir da API
  Future<bool> createUser(String name, String username, String password,
      String passwordConfirm) async {
    User newUser =
        await ApiService().createUser(username, name, password, password);
    Session newSession = await ApiService().createSession(username, password);
    print(newUser);
    print(newSession);
    await saveSessionToPrefs(newSession);
    notifyListeners();
    return true;
  }

  Future<void> updateUser(
    String userId,
    String? login,
    String? name,
    String? password,
    String? passConfirm,
  ) async {
    User updatedUser = await ApiService().updateUser(
      token!,
      userId,
      login: login,
      name: name,
      password: password,
      passwordConfirmation: passConfirm,
    );

    // Determina qual senha utilizar para re-autenticação
    late String usedPassword;

    if (password != null && passConfirm != null) {
      if (password != passConfirm) {
        throw Exception('As senhas não coincidem.');
      }
      usedPassword = password;
      _userPass = password;
    } else {
      if (_userPass == null) {
        throw Exception('Senha atual desconhecida. Faça login novamente.');
      }
      usedPassword = _userPass!;
    }

    Session newSession = await ApiService().createSession(_session!.userLogin, usedPassword);
    _session = newSession;
    notifyListeners();
  }

  Future<void> deleteUser() async {
    final user = await ApiService().getUser(token!, _session!.userLogin);
    await ApiService().deleteUser(token!, user.id as String);
  }

  /// Salva a sessão
  Future<void> saveSessionToPrefs(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(session.toJson());
    await prefs.setString('session', userJson);
    _session = session;
  }
}
