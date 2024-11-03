import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:khub_mobile/api/models/courses/courses_api_model.dart';
import 'package:khub_mobile/api/models/responses/AiResponse.dart';
import 'package:khub_mobile/api/models/responses/EventResponse.dart';
import 'package:khub_mobile/api/models/responses/ForumsResponse.dart';
import 'package:khub_mobile/api/models/responses/NotificationsResponse.dart';
import 'package:khub_mobile/api/models/responses/PublicationsResponse.dart';
import 'package:khub_mobile/api/models/responses/SubThemeResponseModel.dart';
import 'package:khub_mobile/api/models/responses/ThemesResponse.dart';
import 'package:khub_mobile/api/models/responses/UtilityResponse.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class APIClient {
  //factory constructor forwards all arguments and type arguments
  //into the subclass constructor
  //since the generated .g class cannot be referenced directly.
  factory APIClient(Dio dio) = _APIClient;

// Publications
  @GET('/api/publications')
  Future<PublicationsResponse> filterPublications(
      @Queries() Map<String, dynamic> queries);

  @GET('/api/publications/published')
  Future<PublicationsResponse> fetchMyPublications(
      @Queries() Map<String, dynamic> queries);

  @GET('/api/publications/favourites')
  Future<PublicationsResponse> fetchMyFavorites();

  @POST('/api/publications/content-request')
  Future<dynamic> requestContent(@Body() Map<String, dynamic> request);

  @POST('/api/publications')
  @MultiPart()
  Future<dynamic> createPublication(
      {@Part(name: 'publication_category_id') required int resourceType,
      @Part(name: 'sub_theme') required int subTheme,
      @Part(name: 'title') required String title,
      @Part(name: 'description') required String description,
      @Part(name: 'author') String? author,
      @Part(name: 'data_category_id') int? resourceCategory,
      @Part(name: 'link') String? link,
      @Part(name: 'communities') required String? communities,
      @Part(name: 'cover', contentType: 'image/jpeg') File? cover});

  @POST('/api/publications/comment')
  Future<dynamic> addPublicationComment(@Body() Map<String, dynamic> request);

  @GET('/api/publications/add_favourite')
  Future<dynamic> addFavoritePublication(
      @Queries() Map<String, dynamic> queries);

  @GET('/api/lookup/themes')
  Future<ThemesResponse> getThemes();

  @GET('/api/lookup/filetypes')
  Future<FileTypeResponse> getFileTypes();

  @GET('/api/lookup/jobs')
  Future<JobResponse> getJobs();

  @GET('/api/lookup/communities')
  Future<CommunityResponse> getCommunities();

  @GET('/api/lookup/resource-types')
  Future<ResourceTypeResponse> getResourceTypes();

  @GET('/api/lookup/resource-categories')
  Future<ResourceCategoryResponse> getResourceCategories();

  @GET('/api/lookup/preferences')
  Future<PreferenceResponse> getPreferences();

  @GET('/api/lookup/file-categories')
  Future<FileCategoryResponse> getFileCategories();

  @GET('/api/lookup/sub_themes')
  Future<SubThemeResponse> getSubThemes();

  @GET('/api/lookup/sub_themes')
  Future<SubThemeResponse> getSubThemesByTheme(@Query("theme_id") int themeId);

  @GET('/api/members')
  Future<CountryResponse> getMemberStates();

// Formums
  @GET('/api/forums')
  Future<ForumsResponse> getForums(@Queries() Map<String, dynamic> queries);

  @POST('/api/forums')
  @MultiPart()
  Future<dynamic> createForum(
      {@Part(name: 'title') required String title,
      @Part(name: 'description') required String description,
      @Part(name: 'image', contentType: 'image/jpeg') File? image});

  @POST('/api/forums/comment')
  Future<dynamic> addForumComment(@Body() Map<String, dynamic> request);

  // AI
  @POST('/api/ai/summarise')
  Future<AiResponse> summarizePublication(@Body() Map<String, dynamic> request);

  @POST('/api/ai/compare')
  Future<AiResponse> comparePublications(@Body() Map<String, dynamic> request);

  @GET('/api/communities')
  Future<CommunityResponse> fetchCommunityList(
      @Queries() Map<String, dynamic> queries);

  @POST('/api/communities/{id}/members')
  Future<dynamic> joinCommunity(
      @Path('id') int communityId, @Body() Map<String, dynamic> request);

  @DELETE('/api/communities/{id}/members/{userId}')
  Future<dynamic> leaveCommunity(
      @Path('id') int communityId, @Path('userId') int userId);

  @GET('/api/events')
  Future<EventResponse> getEvents(@Queries() Map<String, dynamic> queries);

  @GET('/api/push-notifications')
  Future<NotificationsResponse> getNotifications(
      @Queries() Map<String, dynamic> queries);

  @POST('/api/push-notifications/mark-as-read')
  Future<dynamic> markAllNotificationsAsRead(
      @Body() Map<String, dynamic> request);

  @GET('/api/push-notifications/unread-count')
  Future<UnreadNotificationResponse> getUnreadNotificationCount();

  // Courses
  @GET('/api/courses')
  Future<CoursesResponse> getCourses(@Queries() Map<String, dynamic> queries);
}
