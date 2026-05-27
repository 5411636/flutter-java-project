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

  // ============ 认证相关 ============
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
          'avatarUrl': 'https://i.pravatar.cc/150?img=1',
          'role': 'USER',
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
        'avatarUrl': 'https://i.pravatar.cc/150?img=1',
        'role': 'USER',
      }
    };
  }

  // ============ 职位相关 ============
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
        'last': page >= 4,
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
        'salary': '30k-50k',
        'city': '北京',
        'experience': '3-5年',
        'education': '本科',
        'jobType': '全职',
        'description': '负责公司核心业务Flutter开发，参与技术架构设计，推动性能优化与工程化建设。我们寻找对技术有热情、喜欢挑战的你，一起打造业界领先的移动端产品。\n\n岗位职责：\n1. 负责Flutter跨平台应用开发\n2. 参与技术方案设计和评审\n3. 优化应用性能，提升用户体验\n4. 编写高质量、可维护的代码',
        'skills': ['Flutter', 'Dart', 'iOS', 'Android', 'React Native'],
        'welfare': ['五险一金', '弹性工作', '零食下午茶', '带薪年假', '股票期权', '年度旅游'],
        'active': true,
        'hot': true,
        'viewCount': 1234,
        'company': {
          'id': 1,
          'name': '字节跳动',
          'logoUrl': 'https://ui-avatars.com/api/?name=字节跳动&background=4A90E2&color=fff&size=100',
          'industry': '互联网',
          'scale': '10000人以上',
          'financing': '已上市',
          'intro': '字节跳动是全球领先的互联网科技公司，致力于建设全球化创作与交流平台。',
          'address': '北京市海淀区知春路甲48号',
        },
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

  // ============ 简历相关 ============
  static Future<Map<String, dynamic>> getResume() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'code': 200,
      'message': 'success',
      'data': {
        'id': 1,
        'name': '张三',
        'phone': '13800138000',
        'email': 'zhangsan@example.com',
        'age': 28,
        'gender': '男',
        'city': '北京',
        'education': '本科',
        'school': '北京大学',
        'major': '计算机科学与技术',
        'workingYears': 5,
        'currentPosition': '高级Flutter开发工程师',
        'currentCompany': '字节跳动',
        'expectedPosition': '技术经理',
        'expectedSalary': '40k-60k',
        'jobStatus': '离职-随时到岗',
        'description': '5年移动端开发经验，精通Flutter和React Native，负责过多个大型跨平台项目。',
        'updateTime': '2026-05-25T10:00:00Z',
      }
    };
  }

  static Future<Map<String, dynamic>> updateResume(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'code': 200,
      'message': 'success',
      'data': data,
    };
  }

  // ============ 收藏相关 ============
  static Future<Map<String, dynamic>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'code': 200,
      'message': 'success',
      'data': _generateMockJobs(5),
    };
  }

  static Future<Map<String, dynamic>> addFavorite(int jobId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'code': 200, 'message': '收藏成功'};
  }

  static Future<Map<String, dynamic>> removeFavorite(int jobId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'code': 200, 'message': '已取消收藏'};
  }

  // ============ 聊天相关 ============
  static Future<Map<String, dynamic>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'code': 200,
      'message': 'success',
      'data': [
        {
          'id': 1,
          'companyName': '字节跳动',
          'companyLogo': 'https://ui-avatars.com/api/?name=字节跳动&background=4A90E2&color=fff&size=100',
          'jobTitle': 'Flutter开发工程师',
          'lastMessage': '您好，您的简历已收到，方便聊聊吗？',
          'lastMessageTime': '2026-05-27T10:30:00Z',
          'unreadCount': 2,
        },
        {
          'id': 2,
          'companyName': '阿里巴巴',
          'companyLogo': 'https://ui-avatars.com/api/?name=阿里巴巴&background=FF6A00&color=fff&size=100',
          'jobTitle': '高级Java工程师',
          'lastMessage': '我们团队非常期待您的加入',
          'lastMessageTime': '2026-05-26T15:20:00Z',
          'unreadCount': 0,
        },
        {
          'id': 3,
          'companyName': '腾讯',
          'companyLogo': 'https://ui-avatars.com/api/?name=腾讯&background=07C160&color=fff&size=100',
          'jobTitle': '前端开发',
          'lastMessage': '您的技术栈很符合我们的需求',
          'lastMessageTime': '2026-05-25T09:15:00Z',
          'unreadCount': 1,
        },
      ],
    };
  }

  static Future<Map<String, dynamic>> getMessages(int conversationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'code': 200,
      'message': 'success',
      'data': [
        {
          'id': 1,
          'content': '您好，我看到您投递了我们公司Flutter开发工程师的岗位，方便聊聊吗？',
          'fromMe': false,
          'time': '2026-05-27T10:30:00Z',
        },
        {
          'id': 2,
          'content': '您好，非常感兴趣！我有3年Flutter开发经验，之前在美团工作过',
          'fromMe': true,
          'time': '2026-05-27T10:35:00Z',
        },
        {
          'id': 3,
          'content': '很好，我们团队正在扩张，您什么时候方便来面试？',
          'fromMe': false,
          'time': '2026-05-27T10:40:00Z',
        },
      ],
    };
  }

  static Future<Map<String, dynamic>> sendMessage(int conversationId, String content) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'code': 200,
      'message': 'success',
      'data': {
        'id': DateTime.now().millisecondsSinceEpoch,
        'content': content,
        'fromMe': true,
        'time': DateTime.now().toIso8601String(),
      },
    };
  }

  // ============ 用户设置相关 ============
  static Future<Map<String, dynamic>> getUserSettings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'code': 200,
      'message': 'success',
      'data': {
        'pushEnabled': true,
        'emailEnabled': true,
        'smsEnabled': true,
        'darkMode': false,
        'language': 'zh-CN',
      }
    };
  }

  static Future<Map<String, dynamic>> updateUserSettings(Map<String, dynamic> settings) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'code': 200, 'message': 'success', 'data': settings};
  }

  // ============ Token 管理 ============
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // ============ Mock 数据生成 ============
  static List<Map<String, dynamic>> _generateMockJobs(int count) {
    final companies = [
      {'id': 1, 'name': '字节跳动', 'logoUrl': 'https://ui-avatars.com/api/?name=字节跳动&background=4A90E2&color=fff&size=100', 'industry': '互联网', 'scale': '10000人以上'},
      {'id': 2, 'name': '阿里巴巴', 'logoUrl': 'https://ui-avatars.com/api/?name=阿里巴巴&background=FF6A00&color=fff&size=100', 'industry': '电商', 'scale': '10000人以上'},
      {'id': 3, 'name': '腾讯', 'logoUrl': 'https://ui-avatars.com/api/?name=腾讯&background=07C160&color=fff&size=100', 'industry': '互联网', 'scale': '10000人以上'},
      {'id': 4, 'name': '美团', 'logoUrl': 'https://ui-avatars.com/api/?name=美团&background=FED600&color=333&size=100', 'industry': '本地生活', 'scale': '10000人以上'},
      {'id': 5, 'name': '京东', 'logoUrl': 'https://ui-avatars.com/api/?name=京东&background=E1251B&color=fff&size=100', 'industry': '电商', 'scale': '10000人以上'},
      {'id': 6, 'name': '华为', 'logoUrl': 'https://ui-avatars.com/api/?name=华为&background=CF1111&color=fff&size=100', 'industry': '通信', 'scale': '10000人以上'},
      {'id': 7, 'name': '小米', 'logoUrl': 'https://ui-avatars.com/api/?name=小米&background=FF4B00&color=fff&size=100', 'industry': '硬件', 'scale': '5000-10000人'},
      {'id': 8, 'name': '网易', 'logoUrl': 'https://ui-avatars.com/api/?name=网易&background=EB4B28&color=fff&size=100', 'industry': '互联网', 'scale': '5000-10000人'},
    ];
    final titles = ['Flutter开发工程师', '高级Java工程师', '前端开发', '产品经理', 'UI设计师', '数据分析师', '运营专员', '测试工程师'];
    final cities = ['北京', '上海', '杭州', '深圳', '广州', '成都', '武汉', '西安'];
    final salaries = ['15k-25k', '20k-35k', '25k-40k', '30k-50k', '35k-60k', '40k-70k'];

    return List.generate(count, (i) {
      final company = companies[i % companies.length];
      return {
        'id': i + 1,
        'title': titles[i % titles.length],
        'salary': salaries[i % salaries.length],
        'city': cities[i % cities.length],
        'experience': '${3 + (i % 5)}年',
        'education': i % 2 == 0 ? '本科' : '硕士',
        'viewCount': 100 + i * 37,
        'active': true,
        'hot': i < 3,
        'company': company,
        'createdAt': DateTime.now().subtract(Duration(days: i)).toIso8601String(),
      };
    });
  }
}