class User {
  // int id;
  String name;
  String username;

  User({ required this.name, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      
      name: json['name'],
      username: json['login'],
    );
  }
}
