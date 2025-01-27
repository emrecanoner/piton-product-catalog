import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import '../../auth/repositories/auth_repository.dart';

final splashNotifierProvider =
    AsyncNotifierProvider<SplashNotifier, bool>(() => SplashNotifier());

@injectable
class SplashNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // 3 saniye bekle
    await Future.delayed(const Duration(seconds: 3));
    
    final authRepository = ref.read(authRepositoryProvider);
    return authRepository.isLoggedIn();
  }

  Future<void> skip() async {
    // Skip butonuna basıldığında beklemeyi iptal et
    state = const AsyncValue.data(false);
  }
} 