import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/views/login_screen.dart';
import '../../home/views/home_screen.dart';
import '../providers/splash_provider.dart';
import '../../auth/providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    
    ref.listen(splashProvider, (previous, next) {
      if (next == SplashState.authenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (next == SplashState.unauthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1D1D4E), // Koyu mor arka plan
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: size.width * 0.3,
                  height: size.height * 0.15,
                  color: const Color(0xFF6251DD), // Logo rengi mor
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
                  backgroundColor: const Color(0xFFEF6B4A), // Turuncu buton
                  minimumSize: Size(double.infinity, size.height * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4), // Burada 4 yapıyoruz
                  ),
                ),
                child: Text(
                  'auth.login'.tr(),
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              TextButton(
                onPressed: () async {
                  // Skip butonuna basıldığında remember me kontrolü
                  final isLoggedIn = await ref.read(authStateProvider.notifier).isLoggedIn();
                  if (isLoggedIn && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  } else if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
                child: Text(
                  'common.skip'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF6251DD), // Skip yazısı mor
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
} 