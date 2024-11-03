import 'package:khub_mobile/api/models/author/author_model.dart';

class AuthorModel {
  int id;
  String name;
  String icon;
  String isOrganization;
  String address;
  String telephone;
  String email;
  String createdAt;
  String updatedAt;
  String logo;

  AuthorModel(
      {required this.id,
      required this.name,
      required this.icon,
      required this.isOrganization,
      required this.address,
      required this.telephone,
      required this.email,
      required this.createdAt,
      required this.updatedAt,
      required this.logo});

  factory AuthorModel.fromApiModel(AuthorApiModel model) {
    return AuthorModel(
        id: model.id ?? -1,
        name: model.name ?? '',
        icon: model.icon ?? '',
        isOrganization: model.is_organsiation ?? '',
        address: model.address ?? '',
        telephone: model.telephone ?? '',
        email: model.email ?? '',
        createdAt: model.created_at ?? '',
        updatedAt: model.updated_at ?? '',
        logo: model.logo ?? '');
  }
}
