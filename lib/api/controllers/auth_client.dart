import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:khub_mobile/api/models/responses/ProfileResponse.dart';
import 'package:khub_mobile/api/models/token/token_api_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio) = _AuthClient;

  @POST('/api/login')
  Future<TokenApiModel> login(@Body() Map<String, dynamic> request);

  @GET('/api/refresh')
  Future<TokenApiModel> refreshToken();

  @GET('/api/logout')
  Future<dynamic> logout();

  @POST('/api/forgot-password')
  Future<dynamic> forgotPassword(@Body() Map<String, dynamic> request);

  @GET('/api/profile')
  Future<ProfileResponse> getProfile(@Query('id') int id);

  @POST('/api/profile/update')
  @MultiPart()
  Future<ProfileResponse> updateProfile(
      {@Part(name: 'id') required int id,
      @Part(name: 'firstname') required String firstName,
      @Part(name: 'lastname') required String lastName,
      @Part(name: 'phone') required String phoneNumber,
      @Part(name: 'job') required String job,
      @Part(name: 'email') required String email,
      @Part(name: 'country_id') required int countryId,
      @Part(name: 'preferences') required String preferences,
      @Part(name: 'photo', contentType: 'image/jpeg') File? profilePhoto});

  @POST('/api/register')
  @MultiPart()
  Future<dynamic> register(
      {@Part(name: 'firstname') required String firstName,
      @Part(name: 'lastname') required String lastName,
      @Part(name: 'phone') required String phoneNumber,
      @Part(name: 'job') required String job,
      @Part(name: 'email') required String email,
      @Part(name: 'country_id') required int countryId,
      @Part(name: 'password') required String password,
      @Part(name: 'password_confirmation') required String confirmPassword,
      @Part(name: 'preferences') required String preferences,
      @Part(name: 'photo', contentType: 'image/jpeg') File? profilePhoto});

  @POST('/api/social-login')
  Future<TokenApiModel> socialLogin(@Body() Map<String, dynamic> request);
}
