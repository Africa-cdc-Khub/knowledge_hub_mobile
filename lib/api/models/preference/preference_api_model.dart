import 'package:json_annotation/json_annotation.dart';

part 'preference_api_model.g.dart';

@JsonSerializable()
class PreferenceApiModel {
  int? id;
  String? description;
  String? icon;

  PreferenceApiModel(this.id, this.description, this.icon);

  factory PreferenceApiModel.fromJson(Map<String, dynamic> json) =>
      _$PreferenceApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PreferenceApiModelToJson(this);
}
