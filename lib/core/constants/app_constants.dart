class AppConstants {
  const AppConstants._();
  
  // API Constants
  static const String baseUrl = 'https://assign-api.piton.com.tr/api/rest';
  static const int timeoutDuration = 30000; // 30 seconds
  
  // Storage Keys
  static const String tokenKey = 'token';
  static const String userKey = 'user';
  static const String rememberMeKey = 'remember_me';
  
  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 24);
} 