import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/preference/preference_api_model.dart';

part 'preference_model.g.dart';

@JsonSerializable()
class PreferenceModel {
  int id;
  String name;
  String icon;

  PreferenceModel({required this.id, required this.name, required this.icon});

  factory PreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$PreferenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreferenceModelToJson(this);

  factory PreferenceModel.fromApiModel(PreferenceApiModel model) {
    return PreferenceModel(
        id: model.id ?? -1,
        name: model.description ?? '',
        icon: model.icon ?? '');
  }
}
