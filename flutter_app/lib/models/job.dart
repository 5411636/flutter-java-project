import 'package:json_annotation/json_annotation.dart';

part 'job.g.dart';

@JsonSerializable()
class Job {
  final int id;
  final String title;
  final String salary;
  final String? city;
  final String? experience;
  final String? education;
  final String? jobType;
  final String? description;
  final List<String>? skills;
  final List<String>? welfare;
  final bool active;
  final bool hot;
  final int viewCount;
  final Company? company;

  Job({
    required this.id,
    required this.title,
    required this.salary,
    this.city,
    this.experience,
    this.education,
    this.jobType,
    this.description,
    this.skills,
    this.welfare,
    this.active = true,
    this.hot = false,
    this.viewCount = 0,
    this.company,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);
}

@JsonSerializable()
class Company {
  final int id;
  final String name;
  final String? logoUrl;
  final String? industry;
  final String? scale;
  final String? financing;
  final String? intro;
  final String? address;

  Company({
    required this.id,
    required this.name,
    this.logoUrl,
    this.industry,
    this.scale,
    this.financing,
    this.intro,
    this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
