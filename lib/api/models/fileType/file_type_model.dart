import 'package:json_annotation/json_annotation.dart';

part 'file_type_model.g.dart';

@JsonSerializable()
class FileTypeApiModel {
  int? id;
  String? name;
  String? icon;
  int? is_downloadable;

  FileTypeApiModel(this.id, this.name, this.icon, this.is_downloadable);

  factory FileTypeApiModel.fromJson(Map<String, dynamic> json) => _$FileTypeApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$FileTypeApiModelToJson(this);

}