import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://115.29.232.83:8080/api';
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<void> _addAuthHeader() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // 认证相关
  static Future<Map<String, dynamic>> login(String phone, String code) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'phone': phone,
        'credential': code,
        'type': 'CODE',
      });
      return response.data;
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }

  static Future<void> getVerificationCode(String phone) async {
    try {
      await _dio.post('/auth/code', queryParameters: {'phone': phone});
    } catch (e) {
      throw Exception('获取验证码失败: $e');
    }
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      await _addAuthHeader();
      final response = await _dio.get('/auth/me');
      return response.data;
    } catch (e) {
      throw Exception('获取用户信息失败: $e');
    }
  }

  // 职位相关
  static Future<Map<String, dynamic>> getJobs({
    int page = 0,
    int size = 20,
    String? city,
    String? keyword,
  }) async {
    try {
      final response = await _dio.get('/jobs', queryParameters: {
        'page': page,
        'size': size,
        if (city != null) 'city': city,
        if (keyword != null) 'keyword': keyword,
      });
      return response.data;
    } catch (e) {
      throw Exception('获取职位列表失败: $e');
    }
  }

  static Future<Map<String, dynamic>> getJobDetail(int id) async {
    try {
      final response = await _dio.get('/jobs/$id');
      return response.data;
    } catch (e) {
      throw Exception('获取职位详情失败: $e');
    }
  }

  static Future<Map<String, dynamic>> getHotJobs() async {
    try {
      final response = await _dio.get('/jobs/hot');
      return response.data;
    } catch (e) {
      throw Exception('获取热门职位失败: $e');
    }
  }

  // Token 管理
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
