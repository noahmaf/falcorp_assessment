// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      name: json['name'] as String,
      role: json['role'] as String,
      surname: json['surname'] as String,
      department: json['department'] as String,
      annualLeaveBalance: (json['annual_leave_balance'] as num).toInt(),
      sickLeaveBalance: (json['sick_leave_balance'] as num).toInt(),
      familyLeaveBalance: (json['family_leave_balance'] as num).toInt(),
      location: json['location'] as String,
      manager: json['manager'] as String,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'annual_leave_balance': instance.annualLeaveBalance,
      'sick_leave_balance': instance.sickLeaveBalance,
      'family_leave_balance': instance.familyLeaveBalance,
      'location': instance.location,
      'manager': instance.manager,
      'role': instance.role,
      'department': instance.department,
    };
