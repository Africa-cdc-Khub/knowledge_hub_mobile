import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/models/community_model.dart';

part 'community_entity.g.dart';

@JsonSerializable()
class CommunityEntity {
  int id;
  String name;
  String description;

  CommunityEntity(
      {required this.id, required this.name, required this.description});

  factory CommunityEntity.fromJson(Map<String, dynamic> json) =>
      _$CommunityEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityEntityToJson(this);

  factory CommunityEntity.fromModel(CommunityModel model) {
    return CommunityEntity(
      id: model.id,
      name: model.name,
      description: model.description,
    );
  }
}
