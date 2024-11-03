import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/fileType/file_type_model.dart';

part 'file_type_model.g.dart';

@JsonSerializable()
class FileTypeModel {
  int id;
  String name;
  String icon;
  int isDownloadable;

  FileTypeModel({required this.id,
    required this.name,
    required this.icon,
    required this.isDownloadable});

  factory FileTypeModel.fromJson(Map<String, dynamic> json) =>
      _$FileTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileTypeModelToJson(this);

  factory FileTypeModel.fromApiModel(FileTypeApiModel model) {
    return FileTypeModel(
        id: model.id ?? -1,
        name: model.name ?? '',
        icon: model.icon ?? '',
        isDownloadable: model.is_downloadable ?? -1);
  }
}
