class User {
  final int id;
  String username;
  String name;

  User({required this.id, required this.username, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['login'],
      name: json['name'],
    );
  }
}
