import 'package:khub_mobile/models/community_model.dart';
import 'package:khub_mobile/models/file_category_model.dart';
import 'package:khub_mobile/models/file_type_model.dart';
import 'package:khub_mobile/models/job_model.dart';
import 'package:khub_mobile/models/preference_model.dart';

class UtilityModel {
  List<PreferenceModel> preferences;
  List<JobModel> jobs;
  List<FileCategoryModel> fileCategories;
  List<FileTypeModel> fileTypes;
  List<CommunityModel> communities;

  UtilityModel(
      {required this.preferences,
      required this.jobs,
      required this.fileCategories,
      required this.fileTypes,
      required this.communities});
}
