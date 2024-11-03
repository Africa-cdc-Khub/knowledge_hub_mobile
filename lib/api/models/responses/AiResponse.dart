import 'package:json_annotation/json_annotation.dart';

part 'AiResponse.g.dart';

@JsonSerializable()
class AiResponse {
  final String content;

  AiResponse({required this.content});

  factory AiResponse.fromJson(Map<String, dynamic> json) =>
      _$AiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AiResponseToJson(this);
}
