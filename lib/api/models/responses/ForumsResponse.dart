import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/forums/forum_model.dart';

part 'ForumsResponse.g.dart';

@JsonSerializable()
class ForumsResponse {
  int? status;
  // int? page_size;
  int? total;
  List<ForumApiModel>? data;

  ForumsResponse(this.status, this.data, this.total);

  factory ForumsResponse.fromJson(Map<String, dynamic> json) =>
      _$ForumsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ForumsResponseToJson(this);
}
