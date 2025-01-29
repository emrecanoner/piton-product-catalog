import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../home/views/home_screen.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    final rememberMe = prefs.getBool(AppConstants.rememberMeKey) ?? false;
    
    if (mounted) {
      setState(() {
        _rememberMe = rememberMe;
      });
    }

    if (rememberMe && token != null) {
      // Token varsa ve beni hatırla aktifse otomatik giriş yap
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final success = await ref.read(authStateProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            rememberMe: _rememberMe,
          );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'auth.errors.loginFailed'.tr();
        
        if (e.toString().contains('Invalid credentials')) {
          errorMessage = 'auth.errors.invalidCredentials'.tr();
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  InputDecoration _getInputDecoration(String hint, Size size) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF4F5F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.015,
      ),
      errorStyle: TextStyle(
        fontSize: size.width * 0.025,
        height: 1,
      ),
      errorMaxLines: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final size = MediaQuery.of(context).size;
    final padding = size.height * 0.02;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. BÖLÜM: Logo (En üstte)
                    SizedBox(height: size.height * 0.05),
                    Center(
                      child: SizedBox(
                        width: size.width * 0.2,
                        height: size.height * 0.1,
                        child: Image.asset(
                          'assets/images/Logo.png',
                          color: const Color(0xFF6251DD),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // 2. BÖLÜM: Form alanları (Ortada)
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: size.width * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'auth.welcome_back'.tr(),
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: size.height * 0.005),
                            Text(
                              'auth.login_to_account'.tr(),
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1D1D4E),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            
                            Text('E-mail',
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: size.height * 0.005),
                            TextFormField(
                              controller: _emailController,
                              decoration: _getInputDecoration('john@mail.com', size),
                              validator: (value) {
                                final error = Validators.validateEmail(value);
                                if (error != null) {
                                  return error.replaceAll('. ', '.\n');
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            
                            Text('Password',
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: size.height * 0.005),
                            TextFormField(
                              controller: _passwordController,
                              decoration: _getInputDecoration('••••••••', size),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            
                            // Remember me ve Register
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        activeColor: const Color(0xFF6251DD),
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    const Text(
                                      'Remember me',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6251DD),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6251DD),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),

                    // 3. BÖLÜM: Login butonu (En altta)
                    Center(
                      child: SizedBox(
                        width: size.width * 0.9,
                        height: size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF6B4A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            'auth.login'.tr(),
                            style: TextStyle(
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 