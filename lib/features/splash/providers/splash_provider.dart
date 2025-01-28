import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';

enum SplashState {
  initial,
  authenticated,
  unauthenticated,
}

final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>((ref) {
  return SplashNotifier(ref);
});

class SplashNotifier extends StateNotifier<SplashState> {
  final Ref _ref;

  SplashNotifier(this._ref) : super(SplashState.initial) {
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final authRepository = _ref.read(authRepositoryProvider);
    final prefs = _ref.read(sharedPreferencesProvider);
    
    if (prefs == null) {
      state = SplashState.unauthenticated;
      return;
    }

    final isLoggedIn = await authRepository.isLoggedIn();
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    
    if (isLoggedIn && rememberMe) {
      state = SplashState.authenticated;
    } else {
      // Token var ama beni hatırla yoksa çıkış yap
      if (isLoggedIn && !rememberMe) {
        await authRepository.logout();
      }
      state = SplashState.unauthenticated;
    }
  }

  void skip() {
    state = SplashState.unauthenticated;
  }
} 