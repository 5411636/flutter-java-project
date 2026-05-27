import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String phone;
  final String? name;
  final String? avatarUrl;
  final String? expectedPosition;
  final String? city;
  final String? expectedSalary;
  final String? jobStatus;
  final String? role;

  User({
    this.id,
    required this.phone,
    this.name,
    this.avatarUrl,
    this.expectedPosition,
    this.city,
    this.expectedSalary,
    this.jobStatus,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
