import 'package:flutter/material.dart';
import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';

class AuthController extends ChangeNotifier{
  List<User> users = [];

  Future<bool> createUser(String name, String username, String password, String passwordConfirm) async {
    try {
      User newUser = await ApiService().createUser(username, name, password, passwordConfirm);
      Session newSession = await ApiService().createSession(username, password);
      return true;
    } catch (e) {
      print("Erro ao criar usuário: $e");
      return false;
    }
  }
  