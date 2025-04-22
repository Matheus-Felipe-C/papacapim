import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  Session? _session;

  Session? get session => _session;
  String? get token => _session?.token;

  //Carrega a sessão inicial
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('session');
    if (jsonStr != null) {
      _session = Session.fromJson(jsonDecode(jsonStr));
      notifyListeners();
    }
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

  /// Salva a sessão
  Future<void> saveSessionToPrefs(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(session.toJson());
    await prefs.setString('session', userJson);
    _session = session;
    notifyListeners();
  }
}
