import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) => LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) => json.encode(data.toJson());

class LoginRequestModel {
  String password;
  String username;
  String deviceId;
  String platform;

  LoginRequestModel({
    required this.password,
    required this.username,
    required this.deviceId,
    required this.platform,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) => LoginRequestModel(
    password: json["password"],
    username: json["username"],
    deviceId: json["deviceId"],
    platform: json["platform"],
  );

  Map<String, dynamic> toJson() => {
    "password": password,
    "username": username,
    "deviceId": deviceId,
    "platform": platform,
  };
}
