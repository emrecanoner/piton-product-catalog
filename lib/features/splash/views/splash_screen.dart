import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/views/login_screen.dart';
import '../../home/views/home_screen.dart';
import '../providers/splash_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(splashNotifierProvider, (previous, next) {
      next.whenData((isLoggedIn) {
        if (!next.isLoading) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  isLoggedIn ? const HomeScreen() : const LoginScreen(),
            ),
          );
        }
      });
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1D1D4E), // Yeni arka plan rengi
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 200,  // Yeni genişlik
                  height: 130, // Yeni yükseklik
                  child: Image.asset(
                    'assets/images/Logo.png',
                    color: Colors.blue, // Logo rengini mavi yaptık
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF6B4A), // Yeni turuncu renk
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'auth.login'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => ref.read(splashNotifierProvider.notifier).skip(),
                child: Text(
                  'common.skip'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
} 