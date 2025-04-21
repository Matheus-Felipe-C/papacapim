class Post {
  String id;
  String userLogin;
  String postId;
  String message;
  String createdAt;
  String updatedAt;

  Post({
    required this.id,
    required this.userLogin,
    required this.postId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });
  
  Map<String, dynamic> toJson() => {
    "id": id,
    "user_login": userLogin,
    "post_id": postId,
    "message": message,
    "created_at": createdAt,
    "updated_at": updatedAt,
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