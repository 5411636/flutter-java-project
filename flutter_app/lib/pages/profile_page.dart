import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boss_recruitment/providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 用户信息卡片
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      auth.user?.avatarUrl ?? 'https://i.pravatar.cc/150?img=1',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user?.name ?? '用户',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          auth.user?.phone ?? '',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 数据统计
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('简历被浏览', '128'),
                  _buildStatItem('沟通过', '23'),
                  _buildStatItem('已投递', '15'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 功能菜单
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildMenuItem(Icons.favorite_border, '我的收藏', '12个职位'),
                    _buildMenuItem(Icons.history, '投递记录', '查看投递状态'),
                    _buildMenuItem(Icons.description_outlined, '简历管理', '编辑在线简历'),
                    _buildMenuItem(Icons.person_outline, '身份认证', '提升可信度'),
                    _buildMenuItem(Icons.security, '账号安全', '密码、绑定设置'),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            // 其他
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildMenuItem(Icons.help_outline, '帮助与反馈', ''),
                  _buildMenuItem(Icons.info_outline, '关于我们', ''),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 退出登录
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(
                  onPressed: () {
                    auth.logout();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFE8E8E8)),
                  ),
                  child: const Text('退出登录', style: TextStyle(fontSize: 15)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00C2B3)),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String? subtitle) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF666666)),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle != null && subtitle.isNotEmpty)
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF999999))),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
        ],
      ),
    );
  }
}