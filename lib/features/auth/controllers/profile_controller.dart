import 'package:flutter/material.dart';
import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/features/auth/models/session.dart';

import '../models/user.dart';

class ProfileController extends ChangeNotifier{
  Session? _session;

  Session? get session => AuthController().session;
  

  Future<User> getUser(String login) async {
    return await ApiService().getUser(session!.token, login);
  }

  Future<void> deleteUser() async {
    final user = await getUser(_session!.userLogin);
    await ApiService().deleteUser(session!.token, user.id as String);
  }

  Future<List<User>> getUserList({int? page, String? search}) async {
    final users = await ApiService().getUserList(token: session!.token, page: page, search: search);
    return users;
  }
}
