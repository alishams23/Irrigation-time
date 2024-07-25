class User {
  final int id;
  final String username;
  final String fullName;

  User({
    required this.id,
    required this.username,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
    );
  }
}
