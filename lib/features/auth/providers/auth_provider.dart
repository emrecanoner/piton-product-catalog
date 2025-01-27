import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repository.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<bool>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<bool>> {
  final IAuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.data(false));

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.login(email, password);
      state = AsyncValue.data(result);
      return result;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.register(name, email, password);
      state = AsyncValue.data(result);
      return result;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncValue.data(false);
  }
} 