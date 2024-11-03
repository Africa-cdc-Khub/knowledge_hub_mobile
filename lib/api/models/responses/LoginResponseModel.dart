// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  String code;
  String message;
  String refreshToken;
  String token;

  LoginResponseModel({
    required this.code,
    required this.message,
    required this.refreshToken,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    code: json["code"],
    message: json["message"],
    refreshToken: json["refreshToken"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "refreshToken": refreshToken,
    "token": token,
  };
}
