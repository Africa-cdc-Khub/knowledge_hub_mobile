import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/courses/courses_api_model.dart';

part 'course_model.g.dart';

@JsonSerializable()
class CourseModel {
  final int id;
  final int moodleId;
  final String fullname;
  final String shortname;
  final String coverImage;
  final int categoryId;
  final String summary;
  final String createdAt;
  final String updatedAt;
  final String courseLink;

  CourseModel({
    required this.id,
    required this.moodleId,
    required this.fullname,
    required this.shortname,
    required this.coverImage,
    required this.categoryId,
    required this.summary,
    required this.createdAt,
    required this.updatedAt,
    required this.courseLink,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

  factory CourseModel.fromApiModel(CourseApiModel model) {
    return CourseModel(
      id: model.id ?? -1,
      moodleId: model.moodle_id ?? -1,
      fullname: model.fullname ?? '',
      shortname: model.shortname ?? '',
      coverImage: model.cover_image ?? '',
      categoryId: model.category_id ?? -1,
      summary: model.summary ?? '',
      createdAt: model.created_at ?? '',
      updatedAt: model.updated_at ?? '',
      courseLink: model.course_link ?? '',
    );
  }
}
