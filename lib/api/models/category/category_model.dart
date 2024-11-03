import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryApiModel {
  int? id;
  String? category_name;
  String? category_desc;
  String? created_at;
  String? updated_at;

  CategoryApiModel(this.id, this.category_name, this.category_desc,
      this.created_at, this.updated_at);

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);
}
