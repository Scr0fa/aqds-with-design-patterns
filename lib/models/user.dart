class User {
  final String name;
  final String username;
  final String email;
  final String avatar;

  User({this.name = '',this.username = '', this.email = '', this.avatar = ''});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'] ?? '',
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        avatar: json['avatar'] ?? '');
  }
}