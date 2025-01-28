class User {
  final int id;
  final String email;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
    };
  }

  User copyWith({
    int? id,
    String? email,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
} 