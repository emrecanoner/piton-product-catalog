import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../features/auth/repositories/auth_repository.dart';

// SharedPreferences provider
final sharedPreferencesProvider = StateProvider<SharedPreferences?>((ref) => null);

// Dio provider
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: 'https://assign-api.piton.com.tr/api/rest',
    validateStatus: (status) => true,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ))..interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
});

// Initialize provider
final initializeProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  ref.read(sharedPreferencesProvider.notifier).state = prefs;
});

// AuthRepository provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  if (prefs == null) {
    throw UnimplementedError('SharedPreferences is not initialized');
  }
  return AuthRepository(ref.watch(dioProvider), prefs);
}); 