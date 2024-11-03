import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/community/community_api_model.dart';
import 'package:khub_mobile/cache/models/community_entity.dart';

part 'community_model.g.dart';

@JsonSerializable()
class CommunityModel {
  int id;
  String name;
  String description;
  int publicationsCount;
  int membersCount;
  int forumsCount;
  bool userJoined;
  int isActive;
  bool userPendingApproval;
  bool isLoading;

  CommunityModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.isActive,
      required this.publicationsCount,
      required this.membersCount,
      required this.forumsCount,
      required this.userJoined,
      required this.userPendingApproval,
      this.isLoading = false});

  factory CommunityModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityModelToJson(this);

  Map<String, dynamic> toDbJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'isActive': isActive
      };

  factory CommunityModel.fromApiModel(CommunityApiModel model) {
    return CommunityModel(
        id: model.id ?? -1,
        name: model.community_name ?? '',
        description: model.description ?? '',
        isActive: model.is_active ?? -1,
        publicationsCount: model.publications_count ?? -1,
        membersCount: model.members_count ?? -1,
        forumsCount: model.forums_count ?? -1,
        userJoined: model.user_joined ?? false,
        userPendingApproval: model.user_pending_approval ?? false,
        isLoading: false);
  }

  factory CommunityModel.fromDbEntity(CommunityEntity entity) {
    return CommunityModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        isActive: -1,
        publicationsCount: -1,
        membersCount: -1,
        forumsCount: -1,
        userJoined: false,
        userPendingApproval: false,
        isLoading: false);
  }
}
