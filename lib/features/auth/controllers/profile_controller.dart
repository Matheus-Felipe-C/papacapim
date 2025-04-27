import 'package:flutter/material.dart';
import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/features/auth/models/session.dart';

import '../models/user.dart';

class ProfileController extends ChangeNotifier {
  final AuthController auth;
  bool _isLoading = false;
  User? _user;
  String? _error;

  ProfileController({required this.auth}) {
    auth.addListener(_onAuthChange);
    _initUser();
  }

  String? get error => _error;
  bool get isLoading => _isLoading;
  User? get user => _user;

  void _onAuthChange() {
    if (auth.session != null && _user == null) {
      getUser();
    } else if (auth.session == null) {
      _user = null;
      notifyListeners();
    }
  }

  Future<void> _initUser() async {
    if (auth.isLoadingSession) {
      await Future.doWhile(() => auth.isLoadingSession);
    }

    if (auth.session != null) {
      await getUser();
    }
  }

  @override
  void dispose() {
    auth.removeListener(_onAuthChange);
    super.dispose();
  }

  Future<void> getUser() async {
    try {
      if (auth.isLoadingSession) {
        await Future.doWhile(() => auth.isLoadingSession);
      }
      
      if (auth.session == null || auth.token == null) {
        _error = "Não foi possível carregar a sessão";
        notifyListeners();
        return;
      }
      
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await ApiService().getUser(auth.session!.token, auth.session!.userLogin);

      if (_user == null) {
        _error = "Erro ao carregar dados de usuário";
      }

      print("Usuário carregado com sucesso: ${_user?.toString()}");
    } catch (e) {
      _error = 'Erro ao carregar usuário: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
  }

  Future<void> deleteUser() async {
    await ApiService().deleteUser(auth.token!, _user!.id);
  }

  Future<List<User>> getUserList({int? page, String? search}) async {
    final users = await ApiService()
        .getUserList(token: auth.token!, page: page, search: search);
    return users;
  }
}
