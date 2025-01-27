import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class StorageModule {
  @preResolve  // Asenkron olduğu için preResolve kullanıyoruz
  Future<SharedPreferences> get sharedPreferences => 
      SharedPreferences.getInstance();
} 