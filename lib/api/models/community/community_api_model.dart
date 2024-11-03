import 'package:json_annotation/json_annotation.dart';

part 'community_api_model.g.dart';

@JsonSerializable()
class CommunityApiModel {
  int? id;
  String? community_name;
  String? description;
  int? members_count;
  int? forums_count;
  int? publications_count;
  bool? user_joined;
  int? is_active;
  bool? user_pending_approval;

  CommunityApiModel(
      this.id,
      this.community_name,
      this.description,
      this.members_count,
      this.forums_count,
      this.publications_count,
      this.user_joined,
      this.is_active,
      this.user_pending_approval);

  factory CommunityApiModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityApiModelToJson(this);
}
