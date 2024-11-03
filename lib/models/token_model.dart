import 'package:khub_mobile/api/models/token/token_api_model.dart';
import 'package:khub_mobile/models/user_model.dart';

class TokenModel {
  String tokenType;
  String expiresIn;
  String accessToken;
  String refreshToken;
  UserModel? user;

  TokenModel(
      {required this.tokenType,
      required this.expiresIn,
      required this.accessToken,
      required this.refreshToken,
      required this.user});

  factory TokenModel.fromApiModel(TokenApiModel model) {
    return TokenModel(
        tokenType: model.token_type ?? '',
        expiresIn: model.expires_at ?? '',
        accessToken: model.token ?? '',
        refreshToken: model.refresh_token ?? '',
        user: model.user != null ? UserModel.fromApiModel(model.user!) : null);
  }
}
