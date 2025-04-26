class Session {
  int id;
  String userLogin;
  String token;
  String ip;
  String createdAt;
  String updatedAt;

  Session(
      {required this.id,
      required this.userLogin,
      required this.token,
      required this.ip,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_login': userLogin,
        'token': token,
        'ip': ip,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      userLogin: json['user_login'],
      token: json['token'],
      ip: json['ip'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
