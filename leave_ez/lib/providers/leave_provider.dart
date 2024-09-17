import 'package:flutter/material.dart';
import 'package:leave_ez/models/leave_request.dart';
import 'package:leave_ez/services/api_service.dart';

class LeaveProvider extends ChangeNotifier {
  List<LeaveRequest> _leaveRequests = [];

  List<LeaveRequest> get leaveRequests => _leaveRequests;

  final ApiService _apiService = ApiService();

  Future<void> fetchLeaveRequests(String token) async {
    final response = await _apiService.getLeaveRequests(token);

    if (response.statusCode == 200) {
      _leaveRequests = (response.data as List).map((leaveRequest) {
        return LeaveRequest.fromJson(leaveRequest);
      }).toList();

      notifyListeners();
    }
  }

  Future<void> submitLeaveRequest(
      String token, Map<String, dynamic> leaveData) async {
    await _apiService.submitLeaveRequest(token, leaveData);
    fetchLeaveRequests(token);
  }

  Future<void> approveLeaveRequest(
      String token, String requestId, String status) async {
    await _apiService.approveLeaveRequest(token, requestId, status);
    fetchLeaveRequests(token);
  }
}
