import 'package:flutter/material.dart';
import 'package:boss_recruitment/services/api_service.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  Map<String, dynamic>? _resume;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResume();
  }

  Future<void> _loadResume() async {
    try {
      final response = await ApiService.getResume();
      if (response['code'] == 200) {
        setState(() {
          _resume = response['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('简历'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _resume == null
              ? const Center(child: Text('暂无简历'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 基本信息卡片
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundImage: NetworkImage(_resume!['avatarUrl'] ?? 'https://i.pravatar.cc/150?img=1'),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _resume!['name'] ?? '',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_resume!['currentPosition'] ?? ''} | ${_resume!['currentCompany'] ?? ''}',
                                    style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 14, color: Color(0xFF999999)),
                                      const SizedBox(width: 2),
                                      Text(
                                        _resume!['city'] ?? '',
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 求职状态
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('求职状态', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00C2B3).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _resume!['jobStatus'] ?? '',
                                style: const TextStyle(fontSize: 13, color: Color(0xFF00C2B3)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 期望职位
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('期望职位', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_resume!['expectedPosition'] ?? '', style: const TextStyle(fontSize: 14)),
                                Text(_resume!['expectedSalary'] ?? '', style: const TextStyle(fontSize: 14, color: Color(0xFFFF6B00))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 个人简介
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('个人简介', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Text(
                              _resume!['description'] ?? '',
                              style: const TextStyle(fontSize: 13, color: Color(0xFF666666), height: 1.6),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 教育经历
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('教育经历', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Text(
                              '${_resume!['school'] ?? ''} | ${_resume!['education'] ?? ''} | ${_resume!['major'] ?? ''}',
                              style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
    );
  }
}