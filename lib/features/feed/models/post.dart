import 'package:papacapim/features/auth/models/user.dart';

class Post {
  final String message; // Conteúdo do post
  final User user; // Usuário que criou o post
  int likes; // Número de curtidas
  bool isLikedByCurrentUser; // Indica se o usuário atual curtiu o post

  Post({
    required this.message,
    required this.user,
    this.likes = 0, // Valor padrão: 0 curtidas
    this.isLikedByCurrentUser = false, // Valor padrão: não curtido
  });
}
