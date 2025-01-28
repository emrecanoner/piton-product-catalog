import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../../../core/providers/providers.dart';

// Token provider
final authTokenProvider = StateProvider<String?>((ref) => null);

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  if (prefs == null) {
    throw UnimplementedError('SharedPreferences is not initialized');
  }
  return AuthRepository(ref.watch(dioProvider), prefs);
});

// Auth state provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<bool>>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<bool>> {
  final IAuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.data(false));

  Future<bool> login(String email, String password, {bool rememberMe = false}) async {
    try {
      state = const AsyncValue.loading();
      final success = await _repository.login(email, password, rememberMe: rememberMe);
      state = AsyncValue.data(success);
      return success;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final success = await _repository.register(name, email, password);
      state = AsyncValue.data(success);
      return success;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      state = const AsyncValue.data(false);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
} 