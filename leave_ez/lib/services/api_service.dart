import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:3000',
      headers: {'Content-Type': 'application/json'},
    ));
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
        request: true,
      ));
    }
  }

  Future<Response> login(String username, String password) async {
    return await _dio.post('/login', data: {
      'username': username,
      'password': password,
    });
  }

  Future<Response> submitLeaveRequest(
      String token, Map<String, dynamic> leaveData) async {
    return await _dio.post(
      '/leave-request',
      data: leaveData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<Response> getLeaveRequests(String token) async {
    return await _dio.get(
      '/leave-requests',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<Response> approveLeaveRequest(
      String token, String requestId, String status) async {
    return await _dio.put(
      '/leave-request/$requestId/approve',
      data: {'status': status},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
