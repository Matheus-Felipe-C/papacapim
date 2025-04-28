import 'package:papacapim/features/auth/models/user.dart';

class Post {
  int id;
  String userLogin;
  int? postId;
  String message; // Conteúdo do post
  int likes; // Número de curtidas
  bool isLikedByCurrentUser; // Indica se o usuário atual curtiu o post
  String createdAt;
  String updatedAt;

  Post({
    required this.id,
    required this.userLogin,
    this.postId,
    required this.message,
    this.likes = 0, // Valor padrão: 0 curtidas
    this.isLikedByCurrentUser = false, // Valor padrão: não curtido
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_login': userLogin,
        'post_id': postId,
        'message': message,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userLogin: json['user_login'],
      postId: json['post_id'],
      message: json['message'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
