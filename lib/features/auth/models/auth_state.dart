class AuthState {
  final bool isAuthenticated;
  final String? token;

  const AuthState({
    required this.isAuthenticated,
    this.token,
  });
} 