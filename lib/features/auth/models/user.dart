class User {
  final String login;
  final String name;
  final String password;
  final String? confirmPassword;

  User({
    required this.login, 
    required this.name, 
    required this.password,
    this.confirmPassword,
  });


}