import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/repositories/auth_repository.dart';

final splashNotifierProvider =
    AsyncNotifierProvider<SplashNotifier, bool>(() => SplashNotifier());

@injectable
class SplashNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    
    if (!rememberMe) {
      // Beni hatırla seçili değilse 3 saniye bekle
      await Future.delayed(const Duration(seconds: 3));
    }
    
    final authRepository = ref.read(authRepositoryProvider);
    return authRepository.isLoggedIn();
  }

  Future<void> skip() async {
    // Skip butonuna basıldığında beklemeyi iptal et
    state = const AsyncValue.data(false);
  }
} 