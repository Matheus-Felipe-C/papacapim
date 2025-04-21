import 'package:papacapim/features/auth/models/user.dart';

class Post {
  String id;
  String userLogin;
  String postId;
  String message; // Conteúdo do post
  int likes; // Número de curtidas
  bool isLikedByCurrentUser; // Indica se o usuário atual curtiu o post
  String createdAt;
  String updatedAt;

  Post({
    required this.id,
    required this.userLogin,
    required this.postId,
    required this.message,
    this.likes = 0, // Valor padrão: 0 curtidas
    this.isLikedByCurrentUser = false, // Valor padrão: não curtido
    required this.createdAt,
    required this.updatedAt,
  });
}
