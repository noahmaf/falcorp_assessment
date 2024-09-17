import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leave_ez/models/user.dart';
import 'package:leave_ez/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  User? _user;

  String? get token => _token;
  User? get user => _user;

  final ApiService _apiService = Get.find<ApiService>();

  bool get isAuthenticated => _token != null;

  Future<void> login(String username, String password) async {
    final response = await _apiService.login(username, password);
    if (response.statusCode == 200) {
      _token = response.data['token'];

      _user = User.fromJson(response.data['user']);
      notifyListeners();
    }
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
