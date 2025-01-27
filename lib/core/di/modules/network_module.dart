import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../init/network/network_manager.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio get dio => Dio(BaseOptions(
        baseUrl: 'https://assign-api.piton.com.tr/api/rest',
        headers: {'Content-Type': 'application/json'},
      ))..interceptors.add(PrettyDioLogger());

  @singleton
  NetworkManager networkManager(Dio dio, SharedPreferences preferences) => 
      NetworkManager(dio, preferences);
} 