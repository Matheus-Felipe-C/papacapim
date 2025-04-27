import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:papacapim/features/feed/models/post.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException: $statusCode - $message';
}

class ApiService {
  final String baseUrl = "api.papacapim.just.pro.br";

  Map<String, String> _headers(String token) => {
    "Content-Type": "application/json",
    "Authorization": "Token $token",
  };

  Future<User> createUser({
    required String login,
    required String name,
    required String password,
    required String passwordConfirm,
  }) async {
    final uri = Uri.https(baseUrl, "/users");
    final body = jsonEncode({
      "user": {
        "login": login,
        "name": name,
        "password": password,
        "password_confirmation": passwordConfirm,
      },
    });

    final response = await http.post(uri, headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<Session> createSession(String login, String password) async {
    final uri = Uri.https(baseUrl, "/sessions");
    final body = jsonEncode({"login": login, "password": password});

    final response = await http.post(uri, headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      return Session.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<void> deleteSession(String id, String token) async {
    final uri = Uri.https(baseUrl, "/sessions/$id");
    final response = await http.delete(uri, headers: _headers(token));

    if (response.statusCode != 204) {
      throw ApiException(response.statusCode, "Erro ao encerrar sessão");
    }
  }

  Future<User> updateUser(String token, int userID, {
    String? login, String? name, String? password, String? passwordConfirmation,
  }) async {
    final uri = Uri.https(baseUrl, "/users/$userID");
    final body = <String, dynamic>{};

    if (login != null) body['login'] = login;
    if (name != null) body['name'] = name;
    if (password != null && passwordConfirmation != null) {
      if (password != passwordConfirmation) {
        throw Exception("As senhas não coincidem");
      }
      body['password'] = password;
      body['password_confirmation'] = passwordConfirmation;
    }

    final response = await http.patch(uri, headers: _headers(token), body: jsonEncode({"user": body}));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<List<User>> getUserList({required String token, int? page, String? search}) async {
    final uri = Uri.https(baseUrl, "/users", {
      if (page != null) 'page': page.toString(),
      if (search != null) 'search': search,
    });

    final response = await http.get(uri, headers: _headers(token));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<User> getUser(String token, String login) async {
    final uri = Uri.https(baseUrl, "/users/$login");
    final response = await http.get(uri, headers: _headers(token));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<void> deleteUser(String token, int id) async {
    final uri = Uri.https(baseUrl, "/users/$id");
    final response = await http.delete(uri, headers: _headers(token));

    if (response.statusCode != 204) {
      throw ApiException(response.statusCode, "Erro ao apagar usuário");
    }
  }

  Future<void> followUser(String token, String login) async {
    final uri = Uri.https(baseUrl, "/users/$login/followers");
    final response = await http.post(uri, headers: _headers(token));

    if (response.statusCode != 201) {
      throw ApiException(response.statusCode, "Erro ao seguir usuário");
    }
  }

  Future<List<User>> listFollowers(String token, String login) async {
    final uri = Uri.https(baseUrl, "/users/$login/followers");
    final response = await http.get(uri, headers: _headers(token));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<void> deleteFollow(String token, String login, String id) async {
    final uri = Uri.https(baseUrl, "/users/$login/followers/$id");
    final response = await http.delete(uri, headers: _headers(token));

    if (response.statusCode != 204) {
      throw ApiException(response.statusCode, "Erro ao dar unfollow");
    }
  }

  Future<Post> createPost(String token, String message) async {
    final uri = Uri.https(baseUrl, "/posts");
    final body = jsonEncode({"post": {"message": message}});

    final response = await http.post(uri, headers: _headers(token), body: body);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Post.fromJson(data['post']);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<Post> replyPost(String token, String postId, String message) async {
    final uri = Uri.https(baseUrl, "/posts/$postId/replies");
    final body = jsonEncode({"reply": {"message": message}});

    final response = await http.post(uri, headers: _headers(token), body: body);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Post.fromJson(data['reply']);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<List<Post>> listPosts({
    required String token,
    int page = 1,
    int perPage = 10,
    int? feed,
    String? search,
  }) async {
    final query = {
      'page': page.toString(),
      'per_page': perPage.toString(),
      if (feed != null) 'feed': feed.toString(),
      if (search != null) 'search': search,
    };

    final uri = Uri.https(baseUrl, "/posts", query);
    final response = await http.get(uri, headers: _headers(token));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> posts = data['posts'];
      return posts.map((json) => Post.fromJson(json)).toList();
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<List<Post>> listUserPosts({required String token, required String login}) async {
    final uri = Uri.https(baseUrl, "/users/$login/posts");
    final response = await http.get(uri, headers: _headers(token));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<List<Post>> listReplies({required String token, required String postId}) async {
    final uri = Uri.https(baseUrl, "/posts/$postId/replies");
    final response = await http.get(uri, headers: _headers(token));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<void> deletePost(String token, String postId) async {
    final uri = Uri.https(baseUrl, "/posts/$postId");
    final response = await http.delete(uri, headers: _headers(token));

    if (response.statusCode != 204) {
      throw ApiException(response.statusCode, "Erro ao apagar post");
    }
  }

  Future<bool> likePost(String token, String postId) async {
    final uri = Uri.https(baseUrl, "/posts/$postId/likes");
    final response = await http.post(uri, headers: _headers(token));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<bool> removeLike(String token, String postId) async {
    final uri = Uri.https(baseUrl, "/posts/$postId/likes");
    final response = await http.delete(uri, headers: _headers(token));

    if (response.statusCode == 204 || response.statusCode == 200) {
      return true;
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
