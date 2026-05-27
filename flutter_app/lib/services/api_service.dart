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
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'code': 200,
      'message': 'success',
      'data': {
        'token': 'mock-jwt-token-123456',
        'user': {
          'id': 1,
          'name': '张三',
          'phone': phone,
          'avatar': 'https://i.pravatar.cc/150?img=1',
        }
      }
    };
  }

  static Future<void> getVerificationCode(String phone) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return;
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'code': 200,
      'message': 'success',
      'data': {
        'id': 1,
        'name': '张三',
        'phone': '13800138000',
        'avatar': 'https://i.pravatar.cc/150?img=1',
      }
    };
  }

  // 职位相关
  static Future<Map<String, dynamic>> getJobs({
    int page = 0,
    int size = 20,
    String? city,
    String? keyword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final jobs = _generateMockJobs(size);
    return {
      'code': 200,
      'message': 'success',
      'data': {
        'content': jobs,
        'totalElements': 100,
        'totalPages': 5,
        'size': size,
        'number': page,
      }
    };
  }

  static Future<Map<String, dynamic>> getJobDetail(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'code': 200,
      'message': 'success',
      'data': {
        'id': id,
        'title': '高级Flutter开发工程师',
        'company': '字节跳动',
        'city': '北京',
        'salary': '30k-50k',
        'experience': '3-5年',
        'education': '本科',
        'description': '负责公司核心业务Flutter开发，参与技术架构设计，推动性能优化与工程化建设。',
        'requirements': '1. 3年以上Flutter开发经验\n2. 熟悉Dart语言和Flutter生态\n3. 有跨平台开发经验优先\n4. 良好的沟通协作能力',
        'viewCount': 1234,
        'createdAt': '2026-05-20T10:00:00Z',
      }
    };
  }

  static Future<Map<String, dynamic>> getHotJobs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'code': 200,
      'message': 'success',
      'data': _generateMockJobs(6),
    };
  }

  // Token 管理
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  static List<Map<String, dynamic>> _generateMockJobs(int count) {
    final companies = ['字节跳动', '阿里巴巴', '腾讯', '美团', '京东', '华为', '小米', '网易', '快手', '滴滴'];
    final titles = ['Flutter开发工程师', '高级Java工程师', '前端开发', '产品经理', 'UI设计师', '数据分析师', '运营专员', '测试工程师'];
    final cities = ['北京', '上海', '杭州', '深圳', '广州', '成都', '武汉', '西安'];
    final salaries = ['15k-25k', '20k-35k', '25k-40k', '30k-50k', '35k-60k', '40k-70k'];

    return List.generate(count, (i) => {
      'id': i + 1,
      'title': titles[i % titles.length],
      'company': companies[i % companies.length],
      'city': cities[i % cities.length],
      'salary': salaries[i % salaries.length],
      'experience': '${3 + (i % 5)}年',
      'education': i % 2 == 0 ? '本科' : '硕士',
      'tags': ['五险一金', '弹性工作', '零食下午茶', '带薪年假'].take((i % 3) + 1).toList(),
      'logo': 'https://ui-avatars.com/api/?name=${companies[i % companies.length]}&background=random&size=100',
      'viewCount': 100 + i * 37,
      'createdAt': DateTime.now().subtract(Duration(days: i)).toIso8601String(),
    });
  }
}