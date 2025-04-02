import 'package:papacapim/features/auth/models/session.dart';

class AuthenticatedUser {
  String id;
  String username;
  String name;
  Session session;

  AuthenticatedUser(
      {required this.id,
      required this.name,
      required this.username,
      required this.session});

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      session: json['session'],
    );
  }
}
