// To parse this JSON data, do
//
//     final signUpRequestModel = signUpRequestModelFromJson(jsonString);

import 'dart:convert';

SignUpRequestModel signUpRequestModelFromJson(String str) => SignUpRequestModel.fromJson(json.decode(str));

String signUpRequestModelToJson(SignUpRequestModel data) => json.encode(data.toJson());

class SignUpRequestModel {
  String customerId;
  String identificationNumber;
  DateTime dateOfBirth;

  SignUpRequestModel({
    required this.customerId,
    required this.identificationNumber,
    required this.dateOfBirth,
  });

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) => SignUpRequestModel(
    customerId: json["customerId"],
    identificationNumber: json["identificationNumber"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
  );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "identificationNumber": identificationNumber,
    "dateOfBirth": dateOfBirth.toIso8601String(),
  };
}
