import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/validators.dart';
import '../../home/views/home_screen.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final success = await ref.read(authStateProvider.notifier).register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'auth.errors.registerFailed'.tr();
        
        if (e.toString().contains('already exists')) {
          errorMessage = 'auth.errors.emailExists'.tr();
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
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: size.width * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'auth.welcome'.tr(),
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: size.height * 0.005),
                            Text(
                              'auth.register_account'.tr(),
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1D1D4E),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            Text(
                              'auth.name'.tr(),
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: size.height * 0.005),
                            TextFormField(
                              controller: _nameController,
                              decoration: _getInputDecoration('auth.form.name_placeholder'.tr(), size),
                              validator: (value) {
                                final error = Validators.validateName(value);
                                if (error != null) {
                                  return error.replaceAll('. ', '.\n');
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            Text(
                              'auth.email'.tr(),
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: size.height * 0.005),
                            TextFormField(
                              controller: _emailController,
                              decoration: _getInputDecoration('auth.form.email_placeholder'.tr(), size),
                              validator: (value) {
                                final error = Validators.validateEmail(value);
                                if (error != null) {
                                  return error.replaceAll('. ', '.\n');
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            Text(
                              'auth.password'.tr(),
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: size.height * 0.005),
                            TextFormField(
                              controller: _passwordController,
                              decoration: _getInputDecoration('auth.form.password_placeholder'.tr(), size),
                              obscureText: true,
                              validator: (value) {
                                final error = Validators.validatePassword(value);
                                if (error != null) {
                                  return error.replaceAll('. ', '.\n');
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'auth.login'.tr(),
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
                    Center(
                      child: SizedBox(
                        width: size.width * 0.9,
                        height: size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF6B4A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            'auth.register'.tr(),
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
} 