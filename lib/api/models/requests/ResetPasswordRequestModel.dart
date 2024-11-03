// To parse this JSON data, do
//
//     final resetPasswordRequestModel = resetPasswordRequestModelFromJson(jsonString);

import 'dart:convert';

ResetPasswordRequestModel resetPasswordRequestModelFromJson(String str) => ResetPasswordRequestModel.fromJson(json.decode(str));

String resetPasswordRequestModelToJson(ResetPasswordRequestModel data) => json.encode(data.toJson());

class ResetPasswordRequestModel {
  String username;
  String deviceId;
  String platform;

  ResetPasswordRequestModel({
    required this.username,
    required this.deviceId,
    required this.platform,
  });

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) => ResetPasswordRequestModel(
    username: json["username"],
    deviceId: json["deviceId"],
    platform: json["platform"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "deviceId": deviceId,
    "platform": platform,
  };
}
