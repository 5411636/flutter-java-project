import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boss_recruitment/providers/job_provider.dart';
import 'package:boss_recruitment/pages/job_detail_page.dart';
import 'package:boss_recruitment/pages/chat_page.dart';
import 'package:boss_recruitment/pages/resume_page.dart';
import 'package:boss_recruitment/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().fetchJobs(refresh: true);
      context.read<JobProvider>().fetchHotJobs();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<JobProvider>().fetchJobs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.location_on, size: 20),
            const SizedBox(width: 4),
            const Text('北京', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          _buildJobList(),
          const ChatPage(),
          const ResumePage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00C2B3),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: '职位'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '沟通'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: '简历'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, JobProvider jobProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 搜索栏
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Color(0xFF999999)),
              SizedBox(width: 8),
              Text('搜索职位、公司', style: TextStyle(color: Color(0xFF999999))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00C2B3), Color(0xFF00D4C3)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '春季招聘季 · 直聊模式',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '10000+ 优质岗位 · 在线直聊老板',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '为你推荐',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildJobCard(BuildContext context, job) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobDetailPage(jobId: job.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.salary,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B00),
                        ),
                      ),
                    ],
                  ),
                ),
                if (job.company?.logoUrl != null)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(job.company!.logoUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${job.city ?? ''} | ${job.experience ?? ''} | ${job.education ?? ''}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
            ),
            if (job.company != null) ...[
              const SizedBox(height: 8),
              Text(
                job.company!.name,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildJobList() {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<JobProvider>().fetchJobs(refresh: true);
      },
      child: Consumer<JobProvider>(
        builder: (context, jobProvider, _) {
          if (jobProvider.jobs.isEmpty && jobProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: jobProvider.jobs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildHeader(context, jobProvider);
              }

              final job = jobProvider.jobs[index - 1];
              return _buildJobCard(context, job);
            },
          );
        },
      ),
    );
  }
}
