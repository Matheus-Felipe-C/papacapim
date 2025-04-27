import 'dart:convert';

import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:papacapim/features/feed/models/post.dart';

class ApiService {
  final String baseUrl = "api.papacapim.just.pro.br";

  // Cria um usuário
  Future<User> createUser({
  required String login,
  required String name,
  required String password,
  required String passwordConfirm
}) async {
  try {
    print(jsonEncode({
      "user": {
        "login": login,
        "name": name,
        "password": password,
        "password_confirmation": passwordConfirm
      }
    }));

    final response = await http.post(
      Uri.https(baseUrl, "/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user": {
          "login": login,
          "name": name,
          "password": password,
          "password_confirmation": passwordConfirm
        }
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Usuário: ${data['login']}');
      return User.fromJson(data);
    } else {
      throw Exception("Falha ao criar usuário. Body: ${response.body}");
    }
  } catch (e) {
    print("Erro de conexão: $e");
    throw Exception("Erro de conexão: $e");
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
      print("Erro: ${response.body}. StatusCode: ${response.statusCode}");
      throw Exception("Falha ao criar nova sessão: ${response.body}");
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

  Future<User> updateUser(String token, int userID,
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

  Future<void> deleteUser(String token, int id) async {
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

  import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Post> createPost(String token, String message) async {
  try {
    final response = await http.post(
      Uri.https(baseUrl, "/posts"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        "post": {
          "message": message,
        }
      }),
    );

    if (response.statusCode == 201) {
      print("Post criado com sucesso");
      final Map<String, dynamic> responseData = json.decode(response.body);
      return Post.fromJson(responseData["post"]);
    } else {
      throw Exception("Erro ao criar post: ${response.statusCode}\n${response.body}");
    }
  } catch (e) {
    throw Exception("Erro na comunicação com o servidor: $e");
  }
}

 Future<Post> replyPost(String token, String postId, String message) async {
  if (token.isEmpty) throw ArgumentError('Token não pode ser vazio');
  if (postId.isEmpty) throw ArgumentError('ID do post não pode ser vazio');
  if (message.isEmpty) throw ArgumentError('Mensagem não pode ser vazia');

  try {
    final response = await http.post(
      Uri.https(baseUrl, "/posts/$postId/replies"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({ 
        "reply": {
          "message": message,
        }
      }),
    ).timeout(const Duration(seconds: 10));

    final responseData = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.created) { 
      debugPrint('Resposta criada com sucesso para o post $postId');
      return Post.fromJson(responseData["reply"]);
    } else {
      throw ApiException(
        response.statusCode,
        responseData['error'] ?? 'Erro ao responder post',
      );
    }
  } on http.ClientException catch (e) {
    throw Exception('Erro de conexão: ${e.message}');
  } on TimeoutException {
    throw Exception('Tempo de requisição excedido');
  } on FormatException {
    throw Exception('Resposta do servidor em formato inválido');
  } catch (e) {
    throw Exception('Erro ao responder post: $e');
  }
}

Future<List<Post>> listPosts({
  required String token,
  int page = 1,
  int perPage = 10,
  int? feed,
  String? search,
  bool refresh = false,
}) async {
  if (token.isEmpty) {
    throw ArgumentError('Token de autenticação não pode ser vazio');
  }
  
  final currentPage = refresh ? 1 : page;
  
  if (currentPage < 1) {
    throw ArgumentError('Número da página deve ser maior que 0');
  }
  if (perPage < 1 || perPage > 100) {
    throw ArgumentError('Quantidade por página deve estar entre 1 e 100');
  }

  try {
    final queryParams = {
      'page': currentPage.toString(),
      'per_page': perPage.toString(),
      if (feed != null) 'feed': feed.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    final response = await http.get(
      Uri.https(baseUrl, "/posts", queryParams),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'Cache-Control': 'no-cache', 
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == HttpStatus.ok) {
      final responseData = jsonDecode(response.body);
      
      if (responseData is! Map || responseData['posts'] is! List) {
        throw FormatException('A resposta do servidor não contém a estrutura esperada');
      }
      
      final List<dynamic> postsData = responseData['posts'];
      return postsData.map((json) => Post.fromJson(json)).toList();
    } 
    else {
      final errorData = jsonDecode(response.body);
      throw ApiException(
        response.statusCode,
        errorData['message'] ?? 'Erro ao carregar posts',
      );
    }
  } 
  
  on http.ClientException catch (e) {
    throw Exception('Falha na comunicação com o servidor: ${e.message}');
  } 
  on TimeoutException {
    throw Exception('A requisição demorou muito para responder');
  } 
  on FormatException catch (e) {
    throw Exception('Dados recebidos em formato inválido: ${e.message}');
  } 
  catch (e) {
    throw Exception('Ocorreu um erro inesperado: $e');
  }
}

  Future<List<Post>> listUserPosts(
      {required String token, required String login, String? page}) async {
    final response = await http.get(
      Uri.https(baseUrl, "/users/$login/posts"),
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

  Future<List<Post>> listReplies(
      {required String token, required String postId, String? page}) async {
    final response = await http.get(
      Uri.https(baseUrl, "/posts/$postId/replies"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao pegar as respostas: ${response.statusCode}");
    }
  }

  Future<void> deletePost(String token, String postId) async {
  if (token.isEmpty) {
    throw ArgumentError('Token de autenticação não pode ser vazio');
  }
  if (postId.isEmpty) {
    throw ArgumentError('ID do post não pode ser vazio');
  }

  try {
    final response = await http.delete(
      Uri.https(baseUrl, "/posts/$postId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    ).timeout(const Duration(seconds: 10)); 

    if (response.statusCode == HttpStatus.noContent) { 
      debugPrint("Post $postId removido com sucesso");
    } else {
      final errorData = response.body.isNotEmpty 
          ? jsonDecode(response.body) 
          : null;
      
      throw ApiException(
        response.statusCode,
        errorData?['message'] ?? 'Erro ao apagar post',
      );
    }
  } 
  on http.ClientException catch (e) {
    throw Exception('Falha na comunicação com o servidor: ${e.message}');
  } on TimeoutException {
    throw Exception('Tempo de requisição excedido');
  } on FormatException catch (e) {
    throw Exception('Resposta do servidor em formato inválido: ${e.message}');
  } catch (e) {
    throw Exception('Erro desconhecido ao apagar post: $e');
  }
}

  Future<bool> likePost(String token, String postId) async {
    final response = await http.post(
      Uri.https(baseUrl, "/posts/$postId/likes"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Erro ao curtir post: ${response.body}");
    }
  }

  Future<void> removeLike(String token, String postId) async {
    final response = await http.delete(
      Uri.https(baseUrl, "/posts/$postId/likes"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 201) {
      print("Post descurtido!");
    } else {
      throw Exception("Erro ao curtir post: ${response.body}");
    }
  }
}
