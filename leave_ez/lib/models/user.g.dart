// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      department: json['department'] as String,
      location: json['location'] as String,
      annualLeaveBalance: (json['annual_leave_balance'] as num).toInt(),
      familyLeaveBalance: (json['family_leave_balance'] as num).toInt(),
      sickLeaveBalance: (json['sick_leave_balance'] as num).toInt(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'surname': instance.surname,
      'username': instance.username,
      'email': instance.email,
      'role': instance.role,
      'department': instance.department,
      'location': instance.location,
      'annual_leave_balance': instance.annualLeaveBalance,
      'sick_leave_balance': instance.sickLeaveBalance,
      'family_leave_balance': instance.familyLeaveBalance,
    };
