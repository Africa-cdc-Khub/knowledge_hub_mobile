import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/user/user_api_model.dart';

part 'token_api_model.g.dart';

@JsonSerializable()
class TokenApiModel {
  String? token_type;
  String? expires_at;
  String? token;
  String? refresh_token;
  UserApiModel? user;

  TokenApiModel(this.token_type, this.expires_at, this.token,
      this.refresh_token, this.user);

  factory TokenApiModel.fromJson(Map<String, dynamic> json) =>
      _$TokenApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$TokenApiModelToJson(this);
}
