import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'dart:convert';

part 'publication_entity.g.dart';

@JsonSerializable()
class PublicationEntity {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final int type; // 0: recommended, 1: top searches
  final String content;

  PublicationEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.content,
  });

  factory PublicationEntity.fromJson(Map<String, dynamic> json) =>
      _$PublicationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PublicationEntityToJson(this);

  factory PublicationEntity.fromModel(PublicationModel model, int type) {
    return PublicationEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      imageUrl: model.cover,
      type: type,
      content:
          jsonEncode(model.toJson()), // We'll add toJson() to PublicationModel
    );
  }
}
