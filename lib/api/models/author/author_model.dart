import 'package:json_annotation/json_annotation.dart';

part 'author_model.g.dart';

@JsonSerializable()
class AuthorApiModel {
  int? id;
  String? name;
  String? icon;
  String? is_organsiation;
  String? address;
  String? telephone;
  String? email;
  String? created_at;
  String? updated_at;
  String? logo;

  AuthorApiModel(
      this.id,
      this.name,
      this.icon,
      this.is_organsiation,
      this.address,
      this.telephone,
      this.email,
      this.created_at,
      this.updated_at,
      this.logo);

  factory AuthorApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorApiModelToJson(this);

}
