import 'package:khub_mobile/api/models/user/user_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ProfileResponse.g.dart';

@JsonSerializable()
class ProfileResponse {
  final UserApiModel data;

  ProfileResponse({required this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
