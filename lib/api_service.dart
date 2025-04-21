import 'dart:convert';

import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:papacapim/features/feed/models/post.dart';

class ApiService {
  final String baseUrl = "api.papacapim.just.pro.br";

  // Cria um usuário
  Future<User> createUser(String login, String name, String password,
      String passwordConfirm) async {
    final response = await http.post(Uri.https(baseUrl, "/users"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user": {
            "login": login,
            "name": name,
            "password": password,
            "password_confirmation": passwordConfirm
          }
        }));

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Usuário: ${data['login']}');
      return User.fromJson(data);
    } else {
      throw Exception("Falha ao criar usuário");
    }
  }

  /// Cria uma nova sessão a partir da API
  Future<Session> createSession(String login, String password) async {
    final response = await http.post(Uri.https(baseUrl, "/sessions"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"login": login, "password": password}));

    if (response.statusCode == 200) {
      return Session.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Algo deu errado ao criar uma nova sessão");
    }
  }

  /// Apaga uma sessão existente
  /// P.S - Preciso pesquisar
  Future<void> deleteSession(String id, String token) async {
    final response = await http.delete(
      Uri.https(baseUrl, "/sessions/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 204) {
      print("Sessão encerrada com sucesso");
    } else {
      throw Exception("Erro ao encerrar a sessão: ${response.statusCode}");
    }
  }

  Future<User> updateUser(String token, String userID,
      {String? login,
      String? name,
      String? password,
      String? passwordConfirmation}) async {
    final Map<String, dynamic> body = {};

    final hasPassword = password != null && password.isNotEmpty;
    final hasConfirmation =
        passwordConfirmation != null && passwordConfirmation.isNotEmpty;

    if (login != null) body['login'] = login;
    if (name != null) body['name'] = name;

    if (hasPassword || hasConfirmation) {
      if (password != passwordConfirmation) {
        throw Exception("As senhas não coincidem");
      }

      body['password'] = password;
      body['password_confirmation'] = passwordConfirmation;
    }

    final response = await http.patch(Uri.https(baseUrl, "/users"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 204) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Algo deu errado ao realizar as alterações");
    }
  }

  Future<List<User>> getUserList(
      {required String token, int? page, String? search}) async {
    final queryParameters = <String, String>{};

    if (page != null) queryParameters['page'] = page.toString();
    if (search != null) queryParameters['search'] = search.toString();

    final uri =
        Uri.parse("$baseUrl/users").replace(queryParameters: queryParameters);

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("Falha ao obter usuários: ${response.statusCode}");
    }
  }

  Future<User> getUser(String token, String login) async {
    final response =
        await http.get(Uri.https(baseUrl, "/users/$login"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception("Falha ao obter dados de $login: ${response.statusCode}");
    }
  }

  Future<void> deleteUser(String token, String id) async {
    final response =
        await http.delete(Uri.https(baseUrl, "/users/$id"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 204) {
      print("Usuário apagado com sucesso!");
    } else {
      throw Exception("Erro ao apagar o usuário: ${response.statusCode}");
    }
  }

  Future<void> followUser(String token, String login) async {
    final response = await http.post(
      Uri.https(baseUrl, "/users/$login/followers"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 201) {
      print("Usuário seguido!");
    } else {
      throw Exception("Erro ao seguir usuário: ${response.statusCode}");
    }
  }

  Future<List<User>> listFollowers(String token, String login) async {
    final response =
        await http.get(Uri.https(baseUrl, "/users/$login/followers"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception(
          "Erro ao mostrar lista de seguidores: ${response.statusCode}");
    }
  }

  Future<void> deletefollow(String token, String login, String id) async {
    final response = await http
        .delete(Uri.https(baseUrl, "/users/$login/followers/$id"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 204) {
      print("Usuário unfollowed!");
    } else {
      throw Exception(
          "Erro ao dar unfollow em usuário: ${response.statusCode}");
    }
  }

  Future<void> createPost(String token, String message) async {
    final response = await http.post(Uri.https(baseUrl, "/posts"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    }, body: {
      "post": {
        "message": message,
      }
    });

    if (response.statusCode == 201) {
      print("Post criado");
    } else {
      throw Exception(
          "Erro ao dar unfollow em usuário: ${response.statusCode}");
    }
  }

  Future<Post> replyPost(String token, String postId, String message) async {
    final response = await http.delete(
      Uri.https(baseUrl, "/posts/$postId/replies"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "reply": {
          "message": message,
        }
      }),
    );

    if (response.statusCode == 204) {
      print("Usuário unfollowed!");
      final data = jsonDecode(response.body);
      return Post.fromJson(data);
    } else {
      throw Exception(
          "Erro ao dar unfollow em usuário: ${response.statusCode}");
    }
  }

  Future<List<Post>> listPosts(
      {required String token, int? page, int? feed, String? search}) async {
    final response = await http.get(
      Uri.https(baseUrl, "/posts"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao pegar os posts: ${response.statusCode}");
    }
  }
}
