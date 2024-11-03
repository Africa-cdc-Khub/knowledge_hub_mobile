
import 'package:json_annotation/json_annotation.dart';

part 'job_api_model.g.dart';

@JsonSerializable()
class JobApiModel {
  int? id;
  int? job_id;
  int? classification_id;
  int? isco_id;
  String? name;

  JobApiModel(
      this.id, this.job_id, this.classification_id, this.isco_id, this.name);

  factory JobApiModel.fromJson(Map<String, dynamic> json) => _$JobApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobApiModelToJson(this);
}