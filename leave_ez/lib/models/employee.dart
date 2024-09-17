import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee {
  String name;
  String surname;
  @JsonKey(name: "annual_leave_balance")
  int annualLeaveBalance;
  @JsonKey(name: "sick_leave_balance")
  int sickLeaveBalance;
  @JsonKey(name: "family_leave_balance")
  int familyLeaveBalance;
  String location;
  String manager;
  String role;
  String department;

  Employee({
    required this.name,
    required this.role,
    required this.surname,
    required this.department,
    required this.annualLeaveBalance,
    required this.sickLeaveBalance,
    required this.familyLeaveBalance,
    required this.location,
    required this.manager,
  });

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
