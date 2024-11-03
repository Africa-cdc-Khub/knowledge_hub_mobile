import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/fileType/file_type_model.dart';

part 'file_category_model.g.dart';

@JsonSerializable()
class FileCategoryModel {
  int id;
  String name;
  String icon;
  int isDownloadable;

  FileCategoryModel({required this.id,
    required this.name,
    required this.icon,
    required this.isDownloadable});

  factory FileCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$FileCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileCategoryModelToJson(this);

  factory FileCategoryModel.fromApiModel(FileTypeApiModel model) {
    return FileCategoryModel(
        id: model.id ?? -1,
        name: model.name ?? '',
        icon: model.icon ?? '',
        isDownloadable: model.is_downloadable ?? -1);
  }
}
