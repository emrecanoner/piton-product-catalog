import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../models/user.dart';

abstract class IAuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> register(String name, String email, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<User?> getCurrentUser();
}

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  late Box<User> _userBox;

  AuthRepository() {
    _initHive();
  }

  Future<void> _initHive() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    _userBox = await Hive.openBox<User>('users');
  }

  @override
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final users = _userBox.values.where(
      (user) => user.email == email && user.password == password
    );

    if (users.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool('remember_me') ?? false;
      
      if (rememberMe) {
        await prefs.setString('token', 'dummy_token');
        await prefs.setString('current_user_email', email);
      }
      return true;
    }
    return false;
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simüle edilmiş gecikme

    // Email kontrolü
    final existingUser = _userBox.values.any((user) => user.email == email);
    if (existingUser) {
      return false; // Email zaten kullanımda
    }

    // Yeni kullanıcı oluştur
    final user = User(
      name: name,
      email: email,
      password: password,
    );

    await _userBox.add(user);
    
    // Register sonrası token kaydetmiyoruz
    // Kullanıcı login ekranına yönlendirilecek
    return true;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('current_user_email');
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  // Mevcut kullanıcının bilgilerini getir
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_user_email');
    if (email != null) {
      try {
        return _userBox.values.firstWhere(
          (user) => user.email == email,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

final authRepositoryProvider = Provider<IAuthRepository>((ref) => AuthRepository()); 