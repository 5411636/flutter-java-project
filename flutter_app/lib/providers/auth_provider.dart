import 'package:flutter/material.dart';
import 'package:boss_recruitment/models/user.dart';
import 'package:boss_recruitment/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> login(String phone, String code) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await ApiService.login(phone, code);

      if (response['code'] == 200) {
        final data = response['data'];
        await ApiService.saveToken(data['token']);
        _user = User.fromJson(data['user']);
        _isAuthenticated = true;
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await ApiService.deleteToken();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    try {
      final response = await ApiService.getCurrentUser();
      if (response['code'] == 200) {
        _user = User.fromJson(response['data']);
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      await logout();
    }
  }
}
