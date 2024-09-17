import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String name;
  String surname;
  String username;
  String email;
  String role;
  String department;
  String location;
  @JsonKey(name: "annual_leave_balance")
  int annualLeaveBalance;
  @JsonKey(name: "sick_leave_balance")
  int sickLeaveBalance;
  @JsonKey(name: "family_leave_balance")
  int familyLeaveBalance;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.role,
    required this.department,
    required this.location,
    required this.annualLeaveBalance,
    required this.familyLeaveBalance,
    required this.sickLeaveBalance,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
