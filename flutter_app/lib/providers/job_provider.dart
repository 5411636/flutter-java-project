import 'package:flutter/material.dart';
import 'package:boss_recruitment/models/job.dart';
import 'package:boss_recruitment/services/api_service.dart';

class JobProvider with ChangeNotifier {
  List<Job> _jobs = [];
  List<Job> _hotJobs = [];
  Job? _selectedJob;
  bool _isLoading = false;
  int _currentPage = 0;
  bool _hasMore = true;

  List<Job> get jobs => _jobs;
  List<Job> get hotJobs => _hotJobs;
  Job? get selectedJob => _selectedJob;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchJobs({String? city, String? keyword, bool refresh = false}) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      if (refresh) {
        _currentPage = 0;
        _jobs = [];
        _hasMore = true;
      }
      notifyListeners();

      final response = await ApiService.getJobs(
        page: _currentPage,
        city: city,
        keyword: keyword,
      );

      if (response['code'] == 200) {
        final data = response['data'];
        final List<dynamic> content = data['content'] ?? [];

        List<Job> newJobs = content.map((json) => Job.fromJson(json)).toList();

        _jobs.addAll(newJobs);
        _hasMore = !data['last'];
        _currentPage++;
      }
    } catch (e) {
      debugPrint('获取职位列表失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHotJobs() async {
    try {
      final response = await ApiService.getHotJobs();
      if (response['code'] == 200) {
        final List<dynamic> data = response['data'] ?? [];
        _hotJobs = data.map((json) => Job.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('获取热门职位失败: $e');
    }
  }

  Future<void> fetchJobDetail(int id) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await ApiService.getJobDetail(id);
      if (response['code'] == 200) {
        _selectedJob = Job.fromJson(response['data']);
      }
    } catch (e) {
      debugPrint('获取职位详情失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
