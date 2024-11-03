import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/job/job_api_model.dart';
part 'job_model.g.dart';

@JsonSerializable()
class JobModel {
  int id;
  int jobId;
  int classificationId;
  int iscoId;
  String name;

  JobModel(
      {required this.id,
      required this.jobId,
      required this.classificationId,
      required this.iscoId,
      required this.name});

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobModelToJson(this);

  factory JobModel.fromApiModel(JobApiModel model) {
    return JobModel(
        id: model.id ?? -1,
        jobId: model.job_id ?? -1,
        classificationId: model.classification_id ?? -1,
        iscoId: model.isco_id ?? -1,
      name: model.name ?? ''
    );
  }
}
