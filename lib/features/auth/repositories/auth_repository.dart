import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

abstract class IAuthRepository {
  Future<bool> login(String email, String password, {bool rememberMe = false});
  Future<bool> register(String name, String email, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
}

class AuthRepository implements IAuthRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  
  AuthRepository(this._dio, this._prefs);

  @override
  Future<bool> login(String email, String password, {bool rememberMe = false}) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      print('Login Response: ${response.data}');

      if (response.statusCode == 200 && response.data['action_login'] != null) {
        final token = response.data['action_login']['token'];
        
        // Her durumda token'ı kaydet
        await _prefs.setString('token', token);
        await _prefs.setString('email', email);
        await _prefs.setBool('rememberMe', rememberMe);
        
        _dio.options.headers['Authorization'] = 'Bearer $token';
        
        return true;
      }
      
      if (response.data['message'] != null) {
        throw Exception(response.data['message']);
      }
      throw Exception('Giriş yapılırken bir hata oluştu');
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      print('Register Response: ${response.data}');

      if (response.statusCode == 200 && response.data['action_register'] != null) {
        return login(email, password);
      }
      
      if (response.data['message'] != null) {
        throw Exception(response.data['message']);
      }
      throw Exception('Kayıt olurken bir hata oluştu');
    } catch (e) {
      print('Register Error: $e');
      if (e.toString().contains('already exists')) {
        throw Exception('Bu email adresi zaten kayıtlı');
      }
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _prefs.remove('token');
    await _prefs.remove('email');
    await _prefs.remove('rememberMe');
    _dio.options.headers.remove('Authorization');
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = _prefs.getString('token');
    final rememberMe = _prefs.getBool('rememberMe') ?? false;
    return token != null && rememberMe;
  }
}

// User model
class User {
  final int id;
  final String email;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.token,
  });
} 