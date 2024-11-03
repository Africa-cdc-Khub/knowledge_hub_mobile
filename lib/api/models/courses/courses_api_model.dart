import 'package:json_annotation/json_annotation.dart';

part 'courses_api_model.g.dart';

@JsonSerializable()
class CoursesResponse {
  int? status;
  int? page_size;
  int? total;
  List<CourseApiModel>? data;

  CoursesResponse(this.status, this.page_size, this.total, this.data);

  factory CoursesResponse.fromJson(Map<String, dynamic> json) =>
      _$CoursesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CoursesResponseToJson(this);
}

@JsonSerializable()
class CourseApiModel {
  int? id;
  int? moodle_id;
  String? fullname;
  String? shortname;
  String? cover_image;
  int? category_id;
  String? summary;
  String? created_at;
  String? updated_at;
  String? course_link;

  CourseApiModel(
    this.id,
    this.moodle_id,
    this.fullname,
    this.shortname,
    this.cover_image,
    this.category_id,
    this.summary,
    this.created_at,
    this.updated_at,
    this.course_link,
  );

  factory CourseApiModel.fromJson(Map<String, dynamic> json) =>
      _$CourseApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourseApiModelToJson(this);
}
