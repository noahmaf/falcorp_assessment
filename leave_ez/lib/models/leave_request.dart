import 'package:json_annotation/json_annotation.dart';
import 'employee.dart';

part 'leave_request.g.dart';

@JsonSerializable()
class LeaveRequest {
  String id;
  Employee employee;
  @JsonKey(name: "leave_type")
  String leaveType;
  @JsonKey(name: "start_date")
  DateTime startDate;
  @JsonKey(name: "end_date")
  DateTime endDate;
  String reason;
  String status;
  String duration;

  LeaveRequest({
    required this.id,
    required this.employee,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.duration,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LeaveRequestToJson(this);
}
