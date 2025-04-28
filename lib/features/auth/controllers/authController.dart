import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  Session? _session;
  String? _userPass;
  bool _isLoadingSession = true;

  Session? get session => _session;
  String? get token => _session?.token;
  String? get userPass => _userPass;
  bool get isLoadingSession => _isLoadingSession;

  AuthController() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    _isLoadingSession = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString('session');

    if (sessionJson != null) {
      try {
        _session = Session.fromJson(jsonDecode(sessionJson));
        notifyListeners();
      } catch (e) {
        print("Erro ao carregar sessão: $e");
        await prefs.remove('session');
      }
    }

    _isLoadingSession = false;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session');
    _session = null;
    _userPass = null;
    notifyListeners();
  }

  // Cria um novo usuário
  Future<void> login(String login, String password) async {
    final session = await ApiService().createSession(login, password);
    await saveSessionToPrefs(session);
    print("New user session: ${session.token}");
    _userPass = password;
    notifyListeners();
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
    String login,
    String name,
    String password,
    String passConfirm,
  ) async {
    await ApiService().updateUser(
      token!,
      login: login,
      name: name,
      password: password,
      passwordConfirmation: passConfirm,
    );

    await logout();
    notifyListeners();
  }

  /// Salva a sessão
  Future<void> saveSessionToPrefs(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(session.toJson());
    await prefs.setString('session', userJson);
    _session = session;
    print(_session!.userLogin);
  }
}
