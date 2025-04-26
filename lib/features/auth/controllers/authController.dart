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
  Future<void> createUser(String name, String username, String password,
      String passwordConfirm) async {
    if (password != passwordConfirm) {
      throw Exception("As senhas não coincidem");
    }

    User newUser =
        await ApiService().createUser(login: username, name: name, password: password, passwordConfirm: passwordConfirm);
    Session newSession = await ApiService().createSession(username, password);
    print(newUser);
    print(newSession);
    await saveSessionToPrefs(newSession);
    _userPass = password;
    notifyListeners();
  }

  Future<void> updateUser(
    int userId,
    String? login,
    String? name,
    String? password,
    String? passConfirm,
  ) async {
    await ApiService().updateUser(
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

    Session newSession =
        await ApiService().createSession(_session!.userLogin, usedPassword);
    _session = newSession;
    notifyListeners();
  }

  /// Salva a sessão
  Future<void> saveSessionToPrefs(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(session.toJson());
    await prefs.setString('session', userJson);
    _session = session;
  }
}
