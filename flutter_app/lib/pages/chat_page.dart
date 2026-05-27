import 'package:flutter/material.dart';
import 'package:boss_recruitment/services/api_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final response = await ApiService.getConversations();
      if (response['code'] == 200) {
        setState(() {
          _conversations = response['data'] ?? [];
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
        title: const Text('沟通'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
              ? const Center(child: Text('暂无沟通记录'))
              : ListView.builder(
                  itemCount: _conversations.length,
                  itemBuilder: (context, index) {
                    final chat = _conversations[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(chat['companyLogo'] ?? ''),
                      ),
                      title: Text(chat['companyName'] ?? ''),
                      subtitle: Text(chat['lastMessage'] ?? ''),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(chat['lastMessageTime'] ?? ''),
                            style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                          ),
                          if (chat['unreadCount'] > 0)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00C2B3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${chat['unreadCount']}',
                                style: const TextStyle(fontSize: 10, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to chat detail
                      },
                    );
                  },
                ),
    );
  }

  String _formatTime(String timeStr) {
    try {
      final time = DateTime.parse(timeStr);
      final now = DateTime.now();
      final diff = now.difference(time);
      if (diff.inDays > 0) return '${diff.inDays}天前';
      if (diff.inHours > 0) return '${diff.inHours}小时前';
      if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
      return '刚刚';
    } catch (e) {
      return '';
    }
  }
}