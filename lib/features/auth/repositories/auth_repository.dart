import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';

abstract class IAuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> register(String name, String email, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
}

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository();

  @override
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (email == "test@test.com" && password == "123456") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'dummy_token');
      return true;
    }
    return false;
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (email.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'dummy_token');
      return true;
    }
    return false;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }
}

final authRepositoryProvider = Provider<IAuthRepository>((ref) => AuthRepository()); 